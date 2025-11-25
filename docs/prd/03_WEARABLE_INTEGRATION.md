# PRD: Wearable Data Integration & APIs

## 1. Introduction
This document defines the integration layer for ingesting health and activity data from wearable devices and fitness platforms. RunningCoach operates as a **wearable-agnostic** platform, synthesizing data from multiple sources to feed the Adaptive Training Engine.

**Important:** This PRD focuses on backend API integration and data normalization. Native watch applications are considered future enhancements and are not part of the initial scope.

## 2. Core Integration Principles

### 2.1. Platform-Agnostic Approach
*   Support multiple wearable ecosystems simultaneously per user
*   Normalize vendor-specific data formats into unified internal schema
*   No dependency on any single vendor for core functionality
*   Graceful degradation when specific data sources unavailable

### 2.2. Data Priority Hierarchy
When multiple sources provide the same metric, use this priority order:
1. **Chest Strap/External Sensors:** Most accurate for HR, HRV
2. **Wearable Watch (worn during activity):** GPS, pace, cadence, optical HR
3. **Manual User Entry:** Session RPE, subjective recovery, notes
4. **Overnight Wearable:** Sleep data, morning HRV, resting HR (if worn)
5. **Inferred/Estimated:** Fallback calculations when direct data unavailable

### 2.3. Synchronization Strategy
*   **Real-Time Webhooks:** Preferred method for immediate activity import
*   **Periodic Polling:** Backup mechanism (every 15-60 minutes)
*   **Manual Sync:** User-initiated on-demand refresh
*   **Bidirectional:** Support sending planned workouts to compatible platforms

## 3. Primary Integration: Garmin Health API

### 3.1. Why Garmin First
*   Dominant market share among serious runners (Forerunner, Fenix, Epix series)
*   Robust Health API with extensive data access
*   Proven reliability and real-time webhook support
*   Bidirectional capability (push structured workouts to device calendar)

### 3.2. Authentication & Connection
*   **OAuth 2.0:** User grants RunningCoach access to their Garmin Connect account
*   **Scopes Required:**
    *   `activities:read` - GPS tracks, pace, HR, cadence, power
    *   `dailies:read` - RHR, HRV, sleep, Body Battery
    *   `workouts:write` - Push structured workouts to Garmin calendar
*   **Token Management:** Store access/refresh tokens encrypted at rest

### 3.3. Data Points Ingested

#### Activity Data (Post-Workout)
*   **Core Metrics:**
    *   Activity type (running, cycling, swimming, strength, etc.)
    *   Start time, duration, distance
    *   GPS track (lat/lon samples at 1Hz)
    *   Heart rate stream (average, max, time in zones)
    *   Pace/speed stream
    *   Cadence, vertical oscillation, ground contact time (if available)
    *   Elevation gain/loss
    *   Running power (if supported)
*   **Metadata:** Device model, activity name, notes

#### Daily Health Metrics (Morning/Overnight)
*   **Resting Heart Rate (RHR):** Lowest HR during sleep
*   **Heart Rate Variability (HRV):** RMSSD or SDNN during sleep
*   **Sleep Score:** Total duration, sleep stages (light/deep/REM), quality score
*   **Body Battery:** Garmin proprietary stress/recovery metric (optional)
*   **Stress Score:** Daily stress levels

### 3.4. Webhook Configuration
*   **Trigger:** Garmin sends webhook immediately when:
    *   New activity uploaded to Garmin Connect
    *   Daily summary available (morning HRV, RHR, sleep)
*   **Endpoint:** `POST /webhooks/garmin`
*   **Payload:** Activity ID or daily summary reference
*   **Backend Action:** Fetch full data via Garmin Health API, normalize, store
*   **Idempotency:** Handle duplicate webhooks using `activity_id` or `summary_date`

### 3.5. Pushing Planned Workouts to Garmin
*   **Format:** Garmin FIT Workout format (structured steps)
*   **Content:**
    *   Warm-up: 10 min easy
    *   Work: 4 × 5 min @ Threshold HR + 2 min recovery
    *   Cool-down: 10 min easy
*   **Sync Frequency:** Push next 7 days of workouts daily at midnight UTC
*   **Display:** Appears in Garmin Calendar, guides watch during activity

## 4. Apple Health Integration

### 4.1. Integration Approach
Apple does not provide cloud-to-cloud API access. Integration occurs via **mobile client**:
*   iOS app uses HealthKit framework to read data locally
*   Mobile app syncs data to RunningCoach backend via internal sync API
*   Data stored on-device until uploaded

### 4.2. Data Points Ingested
*   **Activities:** Running workouts, distance, duration, HR (if Apple Watch worn)
*   **Health Metrics:** Resting HR, HRV (morning readings from Apple Watch)
*   **Sleep:** Sleep analysis duration and quality
*   **Nutrition:** Calorie intake (if user logs via Apple Health)

### 4.3. Limitations
*   No webhooks—requires app to be opened periodically for sync
*   HRV only available if Apple Watch worn overnight
*   Less granular data than dedicated running watches

## 5. Additional Wearable Platforms (Phase 2+)

### 5.1. Strava (Aggregator)
*   **Use Case:** Many runners already sync everything to Strava
*   **Integration:** Strava API v3
*   **Data:** Activities from any device synced to Strava
*   **Limitation:** Aggregated data, may duplicate other sources

### 5.2. Fitbit
*   **Integration:** Fitbit Web API
*   **Data:** Activities, HR, sleep, HRV (limited availability)

### 5.3. Polar, Suunto, Coros
*   **Integration:** Via their respective cloud APIs
*   **Priority:** Based on user demand

### 5.4. Whoop, Oura
*   **Focus:** Recovery and readiness metrics (HRV, sleep, strain)
*   **Integration:** APIs available for recovery-focused data

## 6. Data Normalization & Storage

### 6.1. Vendor-Agnostic Schema
Normalize all wearable data into RunningCoach internal format:

**Activity Schema:**
```json
{
  "activity_id": "uuid",
  "user_id": "uuid",
  "source": "garmin|apple_health|strava|manual",
  "external_id": "vendor_activity_id",
  "activity_type": "running|cycling|swimming|strength|other",
  "start_time": "ISO8601",
  "duration_seconds": 3600,
  "distance_meters": 10000,
  "elevation_gain_meters": 150,
  "avg_heart_rate": 145,
  "max_heart_rate": 170,
  "avg_pace_per_km": 360,
  "gps_track": "JSONB or geospatial format",
  "heart_rate_stream": [120, 125, 130, ...],
  "cadence_avg": 178,
  "rpe": null, // User-provided post-workout
  "notes": "Felt strong today"
}
```

**Daily Health Schema:**
```json
{
  "user_id": "uuid",
  "date": "2025-01-15",
  "resting_hr": 48,
  "hrv_rmssd": 65,
  "sleep_duration_minutes": 450,
  "sleep_quality_score": 8,
  "morning_recovery_rating": 7,
  "soreness_rating": 3
}
```

### 6.2. Conflict Resolution
When multiple sources provide same metric:
*   Use data priority hierarchy (chest strap > watch > manual)
*   Store source attribution for each metric
*   Allow manual override for any auto-imported value

### 6.3. Gap Handling
**Missing RPE:** Cannot calculate internal load without RPE
*   Create notification task for user: "Rate your workout from [date]"
*   Do not calculate ACWR until RPE provided
*   Reminder persists until completed

**Missing HRV/Sleep:** Non-critical, use fallback metrics
*   Traffic light system uses available markers only
*   Downweight missing metrics in decision algorithm

### 6.4. HRV Measurement Protocol Validation
Research-validated HRV measurement requires specific timing and duration protocols. The system must distinguish between optimal and acceptable HRV readings:

**HRV Collection Methods:**
*   **Preferred:** Morning HRV reading upon waking, before getting out of bed
*   **Acceptable:** Overnight HRV (RMSSD during sleep from Garmin, Apple Watch, Whoop, Oura)
*   **Duration:** Readings should span 1-5 minutes for reliability
*   **Quality Indicators:**
    *   Readings <1 minute: Flag as "lower quality" but still usable
    *   Readings taken during activity: Reject as invalid
    *   Chest strap measurements: Highest quality (gold standard)
    *   Optical sensor measurements: Acceptable but note reduced accuracy

**Implementation:**
*   **Data Annotation:** Tag each HRV reading with:
    *   `measurement_type`: (morning_waking | overnight_sleep | during_activity | unknown)
    *   `duration_seconds`: Actual measurement duration
    *   `sensor_type`: (chest_strap | optical_wrist | optical_finger)
    *   `quality_score`: (high | medium | low)
*   **Quality Weighting:** Higher quality readings receive more weight in baseline calculations
*   **User Guidance:** For users without overnight wearables, prompt to use chest strap + HRV app (e.g., Elite HRV, HRV4Training) for morning readings
*   **Fallback:** If no HRV data available, increase weight of other readiness markers (RHR, sleep quality, subjective recovery)

**Validation Rules:**
*   Accept HRV 20-120 ms (RMSSD) as physiologically plausible
*   Flag values outside this range for manual review
*   Track HRV trends over time; sudden >20% changes may indicate measurement error or illness

### 6.5. Heart Rate Zone Validation
Vendor-specific HR zones must be normalized to RunningCoach zones based on user's validated physiological baselines (LT HR, Max HR).

**RunningCoach Zone Definitions:**
*   **Zone 1 (Easy):** <Lactate Threshold HR (~70-80% Max HR)
*   **Zone 2 (Tempo/Threshold):** LT HR to LT HR + 10 bpm (~85-90% Max HR)
*   **Zone 3 (VO2max/Hard):** >LT HR + 10 bpm (~90-95% Max HR)

**Baseline Determination:**
*   **Max HR:** User-provided (220 - age as fallback), updated if exceeded during activities
*   **LT HR:** Lab tested (gold standard), 30-min time trial field test, or estimated at 90% Max HR
*   **Zones:** Recalculated whenever baselines updated

**Normalization Process:**
1. **Ingest vendor zones:** Garmin has 5 zones, Apple Watch uses 3, Polar uses 5
2. **Map to activity data:** Extract time-in-zone from vendor format
3. **Recalculate using RunningCoach zones:** Apply user's LT HR and Max HR baselines
4. **Store both:** Keep vendor zones for reference, use normalized zones for training decisions

**Validation & Alerts:**
*   **Exceeded Max HR:** If `activity.max_hr > user.max_hr_baseline`:
    *   Flag activity for review
    *   If consistently exceeded (3+ activities), prompt: "Your max HR baseline may need updating. Recent activities show HR up to [X] bpm."
    *   Auto-update max HR if user confirms
*   **Zone Distribution Analysis:** Track weekly time-in-zone to ensure 80/20 polarized distribution
*   **HR Drift Detection:** Flag activities where avg HR increases >5% for same pace over 4-week period (may indicate overtraining or dehydration)

**Recalculation Trigger:**
*   User updates profile (Max HR, LT HR, recent race times)
*   System detects consistent baseline exceedances
*   Quarterly automatic review of baselines based on performance trends

## 7. Data Validation & Quality Control

### 7.1. Anomaly Detection
Flag suspicious data for review:
*   HR above 220 bpm (likely sensor error)
*   Pace faster than 2:30/km (GPS artifact)
*   Distance > 50km without ultra-race context
*   Negative elevation gain

### 7.2. GPS Track Cleaning
*   Remove obviously erroneous points (teleportation artifacts)
*   Smooth pace calculations using moving averages
*   Calculate Grade Adjusted Pace (GAP) for hilly routes

### 7.3. User Review
*   Display flagged activities with "Data Quality Warning"
*   Allow user to accept, edit, or delete
*   Learn from user corrections to improve detection

## 8. Privacy & Security

### 8.1. Data Minimization
*   Only request scopes necessary for features
*   Do not store granular GPS tracks long-term (aggregate to route summaries after 90 days)
*   Allow users to disable specific data collection (e.g., GPS track storage)

### 8.2. Token Security
*   OAuth tokens encrypted at rest (AES-256)
*   Tokens never exposed to client applications
*   Automatic token refresh handled server-side
*   Revocation support when user disconnects device

### 8.3. User Control
*   **Disconnect:** User can revoke access anytime (deletes tokens, stops sync)
*   **Data Deletion:** Option to delete historical imported data
*   **Selective Sync:** Choose which metrics to import (e.g., disable sleep tracking)

## 9. Scalability & Reliability

### 9.1. Webhook Reliability
*   **Retry Logic:** Vendors may retry failed webhooks
*   **Idempotency:** Use `external_id` to prevent duplicate processing
*   **Queue-Based:** Enqueue webhook payloads, process asynchronously

### 9.2. Rate Limiting
*   Respect vendor API rate limits (typically 100-1000 requests/hour)
*   Implement exponential backoff on failures
*   Cache frequently accessed data (user profiles, device info)

### 9.3. Polling Fallback
If webhooks fail or unsupported:
*   Poll for new activities every 15 minutes during active hours
*   Poll for daily summaries once per day at 6 AM local time
*   Reduce polling frequency during sleep hours

## 10. Technical Architecture

### 10.1. Integration Service Components
*   **API Gateway:** Handles webhook receivers, OAuth flows
*   **Normalization Engine:** Converts vendor formats to internal schema
*   **Sync Scheduler:** Manages polling fallback
*   **Data Validator:** Quality control and anomaly detection
*   **User Notification Service:** Prompts for missing RPE

### 10.2. API Endpoints
*   `POST /webhooks/garmin` - Garmin webhook receiver
*   `POST /webhooks/strava` - Strava webhook receiver
*   `GET /integrations/status` - Check connection status for all linked devices
*   `POST /integrations/garmin/connect` - Initiate OAuth flow
*   `DELETE /integrations/garmin/disconnect` - Revoke access
*   `POST /integrations/sync-now` - Manual sync trigger

### 10.3. Data Flow
```
[Wearable Device]
    ↓ (auto-sync)
[Vendor Cloud: Garmin Connect / Apple Health / Strava]
    ↓ (webhook or API poll)
[RunningCoach Integration Service]
    ↓ (normalize & validate)
[RunningCoach Main Database]
    ↓ (trigger processing)
[Adaptive Training Engine]
```

## 11. Future Enhancements (Post-MVP)

### 11.1. Smart Watch Applications
*   **Garmin Connect IQ App:** Native watch app for real-time guidance
*   **Apple Watch App:** watchOS companion app
*   **Wear OS App:** For Samsung, Pixel Watch
*   **Note:** These are separate products requiring dedicated development teams

### 11.2. Advanced Sensor Integration
*   **Running Power Meters:** Stryd, Garmin RD Pod
*   **Continuous Glucose Monitors:** Supersapiens for fueling insights
*   **Smart Scales:** Withings, Garmin Index for weight/body composition trends

### 11.3. AI-Powered Form Analysis
*   Video upload and gait analysis
*   Cadence and vertical oscillation optimization recommendations

## 12. Success Metrics
*   **Integration Reliability:** >99.5% webhook delivery success rate
*   **Data Freshness:** Activities imported within 5 minutes of completion (via webhook)
*   **User Satisfaction:** >85% of users successfully connect at least one wearable
*   **Data Quality:** <1% of activities require manual correction due to anomalies
*   **RPE Collection:** >80% of activities have RPE logged within 30 minutes

## 13. Related PRDs
*   [00_OVERARCHING_VISION.md](./00_OVERARCHING_VISION.md) - Wearable-agnostic philosophy
*   [02_BACKEND_CORE.md](./02_BACKEND_CORE.md) - Integration service architecture
*   [05_SYNC_INFRASTRUCTURE.md](./05_SYNC_INFRASTRUCTURE.md) - Internal sync after wearable data imported
*   [06_ADAPTIVE_TRAINING_ENGINE.md](./06_ADAPTIVE_TRAINING_ENGINE.md) - Consumes wearable data for decisions
*   [13_EXTERNAL_INTEGRATIONS.md](./13_EXTERNAL_INTEGRATIONS.md) - Additional external API integrations
