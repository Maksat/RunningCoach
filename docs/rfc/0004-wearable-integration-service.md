# RFC 0004: Wearable Integration Service

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0004 |
| **Author(s)** | Integration Specialist |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
To provide "Holistic" coaching, we need data (HR, HRV, Sleep, GPS). This data comes from various sources (Garmin, Apple Health, Strava). We need a robust way to ingest and normalize this data.

### 1.2. Goals
*   **Vendor Agnostic:** Internal system shouldn't care if data came from Garmin or Apple.
*   **Reliable:** Handle webhook failures, rate limits, and data gaps.
*   **Extensible:** Easy to add Coros/Polar later.

## 2. Proposed Solution

### 2.1. Architecture: The Adapter Pattern

We will define a standard **Internal Data Model** and write **Adapters** for each vendor.

#### 2.1.1. Internal Data Model (Normalized)
```typescript
interface NormalizedActivity {
  source: 'garmin' | 'apple' | 'manual';
  externalId: string;
  type: ActivityType; // 'run', 'cycle', 'swim'
  startTime: Date;
  duration: number; // seconds
  distance: number; // meters
  metrics: {
    avgHr?: number;
    maxHr?: number;
    avgCadence?: number;
    elevationGain?: number;
  };
  samples?: {
    // Time-series data
    hr: { time: number; value: number }[];
    gps: { time: number; lat: number; lon: number }[];
  };
}

interface NormalizedDaily {
  date: string; // YYYY-MM-DD
  restingHr?: number;
  hrv?: number; // rMSSD ms
  sleep?: {
    totalSeconds: number;
    quality?: number; // 0-100
  };
}
```

### 2.2. Garmin Integration (Server-Side)
*   **Method:** Garmin Health API (Webhooks).
*   **Auth:** OAuth 1.0a / 2.0.
*   **Flow:**
    1.  User connects Garmin in App -> Redirect to Garmin OAuth.
    2.  Backend stores tokens.
    3.  Garmin sends Webhook -> Backend queues job.
    4.  Worker fetches data -> `GarminAdapter.normalize(data)` -> Save to DB.

### 2.3. Apple Health Integration (Client-Side)
*   **Method:** HealthKit (iOS Native).
*   **Flow:**
    1.  React Native app requests HealthKit permissions.
    2.  Background task (or app open) queries HealthKit for new workouts/samples.
    3.  App normalizes data locally using `AppleHealthAdapter`.
    4.  App syncs `NormalizedActivity` to Backend via standard Sync API.
    *   *Note: Apple Health data flows through the Mobile App, not directly Server-to-Server.*

### 2.4. Conflict Resolution
*   **Priority:** Garmin/Coros (Hardware source) > Strava (Aggregator) > Manual.
*   **De-duplication:** Check `startTime` and `type`. If overlap < 5 mins, treat as same activity. Merge data (prefer Hardware source for metrics, Manual for RPE/Notes).

## 3. Implementation Plan

### 3.1. Phase 1: Garmin
*   Implement OAuth flow.
*   Implement Webhook receiver.
*   Implement `GarminAdapter`.

### 3.2. Phase 2: Apple Health
*   Implement React Native HealthKit module.
*   Implement local `AppleHealthAdapter`.
*   Hook into Sync logic.

## 4. Open Questions
*   **Historical Import:** How far back do we fetch? (Default: 90 days to build baseline).
*   **Rate Limits:** Need robust backoff strategy for Garmin API.
