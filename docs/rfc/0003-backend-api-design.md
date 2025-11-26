# RFC 0003: Backend API & Database Design

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0003 |
| **Author(s)** | Backend Lead |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
The backend serves as the central repository for user data, the heavy-lifting processor for complex analysis, and the integration point for third-party services (Garmin, Strava).

### 1.2. Goals
*   **Type Safety:** End-to-end type safety from DB to Frontend.
*   **Scalability:** Handle high-frequency data (HR streams) efficiently.
*   **Extensibility:** Easy to add new integrations.

## 2. Proposed Solution

### 2.1. Technology Stack
*   **Framework:** NestJS (Modular, Testable).
*   **API Layer:**
    *   **tRPC:** For internal Mobile <-> Backend communication (Type safety).
    *   **REST:** For external webhooks (Garmin, Strava).
*   **Database:** PostgreSQL 16.
*   **ORM:** Prisma or Drizzle (Drizzle preferred for performance/SQL-like feel).

### 2.2. Database Schema (PostgreSQL)

#### 2.2.1. Core Tables
```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  settings JSONB -- Flexible settings
);

-- Activities (Workouts)
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  external_id TEXT, -- Garmin/Strava ID
  source TEXT, -- 'garmin', 'manual', 'apple'
  type TEXT, -- 'run', 'cycle', 'swim'
  start_time TIMESTAMPTZ NOT NULL,
  duration_sec INT,
  distance_meters FLOAT,
  avg_hr INT,
  max_hr INT,
  data_stream JSONB, -- Compressed HR/GPS stream
  rpe INT, -- Subjective load
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily Metrics (Readiness)
CREATE TABLE daily_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  date DATE NOT NULL,
  resting_hr INT,
  hrv_rmssd FLOAT,
  sleep_hours FLOAT,
  soreness_score INT,
  stress_score INT,
  UNIQUE(user_id, date)
);

-- Training Plan
CREATE TABLE training_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  goal_race_date DATE,
  current_phase TEXT
);

-- Scheduled Workouts
CREATE TABLE scheduled_workouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id UUID REFERENCES training_plans(id),
  date DATE NOT NULL,
  type TEXT, -- 'long_run', 'interval'
  description TEXT,
  target_distance_meters FLOAT,
  target_duration_sec INT,
  status TEXT -- 'pending', 'completed', 'skipped'
);
```

### 2.3. API Design

#### 2.3.1. tRPC Routers (Mobile Client)
*   `auth`: Login, Register, Refresh Token.
*   `sync`: `pushChanges`, `pullChanges` (WatermelonDB protocol).
*   `user`: `getProfile`, `updateSettings`.
*   `dashboard`: `getTodaySummary` (Aggregated view).

#### 2.3.2. REST Controllers (Webhooks)
*   `POST /webhooks/garmin/activities`: Receive new activity.
*   `POST /webhooks/garmin/dailies`: Receive sleep/HRV.
*   `POST /webhooks/strava`: Receive activity.

### 2.4. Data Processing Pipeline
1.  **Ingestion:** Webhook receives payload -> Pushes to Redis Queue (`activity-processing`).
2.  **Processing (Worker):**
    *   Fetch full activity details from Vendor API.
    *   Normalize data to internal `Activity` schema.
    *   Calculate Load (TRIMP, etc.).
    *   Save to DB.
    *   Trigger `AnalysisEngine` (re-calculate readiness/plan).
3.  **Notification:** Send push notification to user ("New Run Analyzed").

## 3. Implementation Plan

### 3.1. Phase 1: Core
*   Setup NestJS + Drizzle + PostgreSQL.
*   Implement Auth.
*   Implement Sync endpoints.

### 3.2. Phase 2: Integrations
*   Implement Garmin Webhook receiver.
*   Implement Normalization logic.

## 4. Security
*   **PII:** Health data is sensitive. Ensure strict access controls.
*   **Webhooks:** Verify signatures from Garmin/Strava to prevent spoofing.
