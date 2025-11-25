# PRD: Backend Core & Infrastructure

## 1. Introduction
This document defines the technical specifications for the "Brain" of the RunningCoach application. The Backend Core is responsible for the **Multi-System Readiness Assessment**, heavy computational processing, and the orchestration of the adaptive training logic. It serves as the central source of truth for the user's physiological state.

## 2. System Architecture

The backend follows a **Service-Oriented Architecture (SOA)** or **Modular Monolith** design, prioritizing the separation of the "Analysis Engine" from the "API Layer".

### 2.1. High-Level Components
*   **API Gateway**: Stateless, handles client requests.
*   **The "Brain" (Worker Cluster)**: Executes the 4-System Analysis logic.
*   **Primary Database (OLTP)**: PostgreSQL. Stores User Profile, Plans, and the "Body State" snapshot.
*   **Time-Series Store**: Optimized storage for high-frequency heart rate/GPS data.
*   **Job Queue**: Redis-backed queue for asynchronous processing.

## 3. Data Domain & Schema Design

### 3.1. Core Entities

#### **User**
*   **Identity**: `id`, `email`, `password_hash`.
*   **Physiology**: `dob`, `gender`, `weight`, `height`.
*   **Baselines**: `resting_hr`, `hrv_baseline`, `max_hr`.
*   **LifeContext**: `travel_frequency`, `stress_level`, `sleep_avg`.

#### **BodyState (The Snapshot)**
*   **Context**: `user_id`, `date`.
*   **CardioSystem**: `status` (Green/Yellow/Red), `hrv_score`, `rhr_score`.
*   **MuscularSystem**: `status` (Green/Yellow/Red), `soreness_score`, `volume_fatigue`.
*   **SkeletalSystem**: `status` (Green/Yellow/Red), `acwr_score`, `impact_load`.
*   **NeuralSystem**: `status` (Green/Yellow/Red), `cns_fatigue`, `sleep_score`.
*   **OverallReadiness**: `score` (0-100), `directive` ("Push", "Maintain", "Recover").

#### **Activity (Workout)**
*   **Metadata**: `id`, `user_id`, `timestamp`, `source`.
*   **Metrics**: `duration`, `distance`, `avg_hr`, `max_hr`, `elevation`.
*   **Load**: `internal_load` (RPE * Duration), `external_load` (Distance/Pace).
*   **Impact**: `ground_contact_time`, `vertical_oscillation` (if available).

#### **TrainingPlan**
*   **Meta**: `id`, `user_id`, `goal_race_date`.
*   **Phases**: `Base`, `Build`, `Peak`, `Taper`.
*   **AdaptationLog**: History of *why* the plan changed (e.g., "Reduced volume due to CNS fatigue").

## 4. API Specification

### 4.1. Client Endpoints
*   `GET /dashboard`: Returns the `BodyState` and today's `ScheduledWorkout`.
*   `POST /checkin`: Submit morning subjective data (Sleep, Soreness, Stress).
*   `POST /activity`: Upload a completed workout.
*   `POST /life-event`: Log "Sickness", "Travel", or "Injury".

### 4.2. Integration Endpoints
*   `POST /webhooks/garmin`: Ingest passive health data (HRV, Sleep).
*   `POST /webhooks/apple`: Ingest HealthKit data.

## 5. Core Processing Pipelines

### 5.1. The Multi-System Analysis Engine
**Trigger**: Morning Check-in OR New Health Data.
**Logic**:
1.  **Cardio-Respiratory Analysis**:
    *   Compare `last_night_hrv` vs `baseline_30d`.
    *   Compare `resting_hr` vs `baseline_30d`.
    *   *Result*: If HRV < baseline - 1SD, set Cardio = Yellow.
2.  **Muscular Analysis**:
    *   Input: `subjective_soreness` (1-10) + `recent_volume` (7-day sum).
    *   *Result*: If Soreness > 5 OR Volume > 120% of baseline, set Muscular = Yellow/Red.
3.  **Skeletal Analysis**:
    *   Calculate **ACWR** (Acute:Chronic Workload Ratio).
    *   *Result*: If ACWR > 1.3, set Skeletal = Yellow. If > 1.5, set Red.
4.  **Neural/CNS Analysis**:
    *   Input: `sleep_quality` + `mental_stress`.
    *   *Result*: If Sleep < 5h OR Stress > 7/10, set CNS = Red.
5.  **Synthesis**:
    *   Generate `OverallReadiness` and `CoachNote`.
    *   *Example*: "Legs are good, but CNS is fried. Easy run only."

### 5.2. Adaptive Scheduler
**Trigger**: `BodyState` update returns "Red" or "Yellow".
**Logic**:
*   **If Red**: Swap today's workout for "Rest" or "Active Recovery". Push key workout to next available slot.
*   **If Yellow**: Reduce intensity by 10-20% OR cut volume.
*   **If Green**: Keep plan as is.

### 5.3. Life Event Handler
**Trigger**: User reports "Sick" or "Travel".
**Logic**:
*   **Sick**: Clear next 3 days. Insert "Return to Run" protocol starting Day 4.
*   **Travel**: Replace Long Run with "Maintenance Intervals" (Short, intense, time-efficient).

## 6. Technology Stack
*   **Language**: Python (FastAPI) - for easy integration with Data Science libraries.
*   **Database**: PostgreSQL.
*   **Queue**: Redis + Celery.
*   **Hosting**: Docker / Kubernetes.

## 7. Security & Privacy
*   **Data Minimization**: Only store what is needed for the analysis.
*   **Encryption**: AES-256 for database at rest.
*   **User Control**: "Delete My Data" button is prominent.
