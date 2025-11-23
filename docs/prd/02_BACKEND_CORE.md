# PRD: Backend Core & Infrastructure

## 1. Introduction
This document defines the technical specifications for the "Brain" of the RunningCoach application. The Backend Core is responsible for data ingestion, heavy computational processing, persistent storage, and the orchestration of the adaptive training logic. It serves as the central source of truth for the user's training state.

## 2. System Architecture

The backend follows a **Service-Oriented Architecture (SOA)** or **Modular Monolith** design, prioritizing separation of concerns between the API layer (serving the client) and the Worker layer (processing data).

### 2.1. High-Level Components
*   **API Gateway / Server**: Handles HTTP requests from the Mobile Client and Third-Party Webhooks. Stateless and horizontally scalable.
*   **Asynchronous Worker Cluster**: Executes background jobs (data normalization, metric calculations, plan generation).
*   **Primary Database (OLTP)**: Relational database (PostgreSQL recommended) for structured user data, plans, and activities.
*   **Time-Series Store (Optional)**: Optimized storage for high-frequency heart rate/GPS data (e.g., TimescaleDB or InfluxDB), or a partitioned table in Postgres.
*   **Job Queue**: Redis-backed queue (e.g., Sidekiq, BullMQ, Celery) for managing asynchronous tasks.
*   **Cache Layer**: Redis for caching computed metrics and session data.

## 3. Data Domain & Schema Design

### 3.1. Core Entities

#### **User**
*   **Identity**: `id`, `email`, `password_hash`, `auth_provider_ids`.
*   **Profile**: `dob`, `gender` (for biological norms), `weight`, `height`.
*   **Settings**: `preferred_units`, `notification_preferences`.
*   **Baselines**: `resting_hr_baseline`, `hrv_baseline`, `max_hr`, `lactate_threshold_hr`.
*   **ResponderStatus**: `classification` (High/Moderate/Low), `last_updated_at`.

#### **Activity (Workout)**
*   **Metadata**: `id`, `user_id`, `timestamp`, `source` (Manual, Garmin, Apple Health), `external_id`.
*   **Core Metrics**: `duration_minutes`, `distance_meters`, `avg_hr`, `max_hr`, `elevation_gain`.
*   **Subjective**: `rpe` (1-10), `feeling` (1-5), `notes`.
*   **Calculated**: `internal_load` (RPE * Duration), `training_impulse` (TRIMP - if HR available).
*   **Samples**: JSONB or separate table for time-series data (HR, Pace, Cadence, Power).

#### **DailyMetric**
*   **Context**: `user_id`, `date`.
*   **Physiological**: `resting_hr`, `hrv_rmssd`, `weight`.
*   **Sleep**: `sleep_duration_minutes`, `sleep_quality_score` (1-10), `sleep_index` (Duration * Quality).
*   **Subjective**: `morning_readiness` (1-10), `soreness` (1-10), `stress` (1-10), `mood` (1-10).
*   **Calculated**: `readiness_score` (Traffic Light result).

#### **TrainingPlan**
*   **Meta**: `id`, `user_id`, `goal_race_date`, `goal_race_distance`, `start_date`, `status` (Active, Archived).
*   **Phases**: JSON structure defining `Base`, `Build`, `Peak`, `Taper` date ranges.
*   **Version**: Integer, incremented on every regeneration.

#### **ScheduledWorkout**
*   **Context**: `plan_id`, `date`, `user_id`.
*   **Prescription**: `type` (Long Run, Interval, Recovery, Strength), `target_duration`, `target_distance`, `target_intensity_zone`, `description`.
*   **Status**: `state` (Planned, Completed, Skipped, Missed).
*   **Link**: `completed_activity_id` (Foreign Key to Activity).

#### **RollingStats (Derived)**
*   **Context**: `user_id`, `date`.
*   **Load**: `acute_load` (7-day EWMA), `chronic_load` (28-day EWMA).
*   **Ratios**: `acwr` (Acute/Chronic), `tsb` (Chronic - Acute).
*   **Monotony**: `weekly_load_mean` / `weekly_load_std_dev`.

## 4. API Specification

The API should be RESTful, versioned (e.g., `/api/v1`), and secured via Token Authentication (JWT).

### 4.1. Client Endpoints
*   `GET /sync`: Returns all changed data since `last_sync_timestamp` (See [05_SYNC_INFRASTRUCTURE.md](./05_SYNC_INFRASTRUCTURE.md)).
*   `POST /sync`: Accepts a batch of offline changes (activities, metrics, workout status updates).
*   `POST /onboarding`: Submit initial profile and goals to generate the first plan.
*   `GET /plan/current`: Fetch the active training plan and upcoming schedule.
*   `POST /plan/regenerate`: User-initiated request to re-optimize the plan (e.g., after changing availability).

### 4.2. Integration Endpoints
*   `POST /webhooks/garmin`: Receiver for Garmin Health API pushes.
*   `POST /webhooks/strava`: Receiver for Strava activity pushes.
*   `POST /webhooks/apple`: Receiver for Apple HealthKit background delivery (via client relay).

## 5. Core Processing Pipelines

### 5.1. Data Ingestion & Normalization
1.  **Trigger**: Webhook received or Client Sync.
2.  **Action**: Enqueue `NormalizeActivityJob`.
3.  **Logic**:
    *   Map vendor-specific fields to internal schema.
    *   Validate data integrity (reject impossible values).
    *   **Critical**: If RPE is missing, create a "Pending Task" for the user to input RPE via the app (Notification).
    *   Calculate `internal_load` = `duration_minutes` * `rpe`.

### 5.2. Metrics Calculation Engine
1.  **Trigger**: `Activity` created/updated OR `DailyMetric` logged.
2.  **Action**: Enqueue `UpdateRollingStatsJob`.
3.  **Logic**:
    *   Recalculate **Acute Load** (7-day Exponentially Weighted Moving Average).
    *   Recalculate **Chronic Load** (28-day EWMA).
    *   Compute **ACWR** = Acute / Chronic.
    *   Compute **TSB** = Chronic - Acute.
    *   Compute **Monotony** (if end of week) = Mean Daily Load / SD.
    *   **Safety Check**: If ACWR > 1.5 or Monotony > 2.0, flag `RiskAlert`.

### 5.3. Adaptive Orchestration (The "Brain")
1.  **Trigger**:
    *   `DailyMetric` logged (Morning check).
    *   `Activity` missed (Midnight cron job).
    *   `RiskAlert` generated.
2.  **Action**: Enqueue `EvaluatePlanAdaptationJob`.
3.  **Logic**:
    *   **Traffic Light Check**:
        *   Fetch latest HRV, Sleep, RPE, Soreness.
        *   Apply logic:
            *   **Green**: No change.
            *   **Yellow**: Reduce intensity 5-10% OR volume 20% for *today's* workout.
            *   **Red**: Convert today to Rest or Recovery Run.
    *   **Structural Check**:
        *   If `RiskAlert` (ACWR > 1.5), trigger **Plan Regeneration** to lower future volume.
        *   If "Missed Long Run", trigger **Plan Regeneration** to redistribute load (prioritize Long Run over Intervals).
4.  **Output**:
    *   Update `ScheduledWorkout` entries in DB.
    *   Create `PlanUpdateNotification` for the user.

## 6. Technology Stack Recommendations

*   **Language**: Python (Django/FastAPI) or TypeScript (Node.js/NestJS) - Python preferred for data science/ML libraries (Pandas/Scikit-learn) needed for future "Responder Classification".
*   **Database**: PostgreSQL (Robust, supports JSONB for flexible schema, excellent time-series support via extensions).
*   **Queue**: Redis + Celery (Python) or BullMQ (Node).
*   **Hosting**: Containerized (Docker) on AWS/GCP.

## 7. Security & Compliance

*   **Health Data**: All health-related data (HR, Weight, Sleep) must be treated as sensitive.
*   **Encryption**:
    *   **At Rest**: DB volume encryption.
    *   **In Transit**: TLS 1.3 for all API traffic.
*   **Privacy**:
    *   Support "Data Export" and "Account Deletion" (GDPR Right to be Forgotten).
    *   Anonymize data before using it for aggregate ML model training (Responder Classification).

## 8. Scalability Considerations

*   **Idempotency**: Webhooks from wearables often retry. Ensure `event_id` processing is idempotent to prevent duplicate activities.
*   **Batch Processing**: Sync endpoints should handle batched uploads to reduce network overhead.
*   **Caching**: Cache the "Home Screen" payload (Current Plan + Today's Status) in Redis, invalidating only on updates.
