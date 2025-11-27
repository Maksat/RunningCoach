# RFC 0002: Mobile Application Architecture

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0002 |
| **Author(s)** | Mobile Lead |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
The RunningCoach mobile application is the primary interface for the athlete and the central hub for the "Holistic Coach" experience. As defined in [01_MOBILE_CLIENT.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/01_MOBILE_CLIENT.md), the app must provide intelligent, adaptive guidance based on a complex synthesis of body metrics.

Following the **hybrid thick-client architecture** defined in [RFC 0001: System Architecture](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/rfc/0001-system-architecture.md), the mobile app hosts the "Adaptive Training Engine" (the Brain) locally. This ensures coaching decisions are made instantly with zero latency, function fully offline, and protect user privacy by keeping health data on-device until explicitly synced. This RFC details the technical architecture required to deliver this premium, offline-first experience.

### 1.2. Problem Statement
We need to build a mobile application that:
1.  **Functions 100% Offline:** Athletes often train in areas with poor connectivity. The app must be fully functional without a network.
2.  **Executes Complex Logic Locally:** The "Brain" must run on the device to provide zero-latency feedback and privacy.
3.  **Delivers a Premium UX:** The design demands high-fidelity animations ("Glassmorphism"), smooth transitions, and immediate responsiveness to build trust.
4.  **Syncs Seamlessly:** Data must flow reliably between the Watch, Phone, and Cloud without user intervention.

### 1.3. Goals & Non-Goals
**Goals:**
*   **Offline-First Architecture:** Local database as the single source of truth for the UI.
*   **Shared Logic Execution:** Seamless integration of the `@runningcoach/engine` TypeScript package.
*   **High-Performance UI:** Maintain 60fps (120fps on ProMotion) during interactions and animations.
*   **Robust Synchronization:** Reliable delta sync with the backend and BLE sync with wearables.
*   **Modular Design:** Feature-based directory structure for scalability.

**Non-Goals:**
*   **Web-based UI:** We are not using a WebView wrapper; this is a native experience using React Native.
*   **Social Features:** Social networking is explicitly out of scope for this RFC (as per PRD).
*   **Streaming:** No video streaming architecture is required for the MVP.

### 1.4. Dependencies
**Related PRDs:**
*   [01_MOBILE_CLIENT.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/01_MOBILE_CLIENT.md) - UX/UI Requirements
*   [03_WEARABLE_INTEGRATION.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/03_WEARABLE_INTEGRATION.md) - Watch Connectivity
*   [04_TRAINING_GUIDANCE.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/04_TRAINING_GUIDANCE.md) - Training Logic Requirements
*   [06_ADAPTIVE_TRAINING_ENGINE.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/06_ADAPTIVE_TRAINING_ENGINE.md) - Logic Engine
*   [07_LOAD_MANAGEMENT.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/07_LOAD_MANAGEMENT.md) - ACWR Charts & Load Tracking
*   [10_NUTRITION_FUELING.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/10_NUTRITION_FUELING.md) - Fueling Card on Dashboard

**Related RFCs:**
*   [0001-system-architecture.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/rfc/0001-system-architecture.md) - System-wide constraints

**External Dependencies:**
*   **Expo SDK:** For build and runtime environment.
*   **WatermelonDB:** For local persistence.
*   **Reanimated:** For animations.
*   **Victory Native:** For charting.
*   **@kingstinct/react-native-healthkit:** iOS HealthKit integration for health metrics.
*   **react-native-health-connect:** Android Health Connect integration.
*   **react-native-ble-plx:** Bluetooth Low Energy for watch communication.

### 1.5. Success Metrics
*   **Cold Start Time:** < 1.5 seconds to interactive Dashboard.
*   **Frame Rate:** Consistent 60fps during scrolling and navigation transitions.
*   **Sync Latency:** Changes reflect on the server < 2 seconds after connection is restored.
*   **Offline Reliability:** 0 crashes caused by network reachability issues.
*   **Battery Impact:** < 5% drain per hour of active foreground usage.
*   **Logic Update Speed:** New Brain versions deployed to 90% of active users within 24 hours (system-wide metric).
*   **Cross-Device Consistency:** Data available on all devices within 5 seconds of sync (system-wide metric).
*   **Data Consistency:** Zero data loss during sync conflicts (system-wide metric).

## 2. Proposed Solution

### 2.1. High-Level Design
We will adhere to a **Reactive, Offline-First Layered Architecture**. The UI never talks directly to the API; it observes the Local Database. The Sync Engine handles network communication in the background.

```mermaid
graph TD
    subgraph UI_Layer ["UI Layer (React Native)"]
        Screens[Screens (Dashboard, Plan, etc.)]
        Components[Shared Components]
        Nav[Navigation]
    end

    subgraph State_Layer ["State Layer"]
        Zustand[Zustand (Global UI State)]
        Observables[WatermelonDB Observables]
    end

    subgraph Domain_Layer ["Domain Layer (The Brain)"]
        Engine["@runningcoach/engine (Shared Logic)"]
        Hooks[Custom Hooks]
    end

    subgraph Data_Layer ["Data Layer"]
        WDB[(WatermelonDB - SQLite)]
        Models[Data Models]
    end

    subgraph Infra_Layer ["Infrastructure Layer"]
        Sync[Sync Adapter (tRPC)]
        BLE[BLE Manager]
        Sensors[HealthKit / Sensors]
    end

    Screens --> Observables
    Screens --> Zustand
    Observables --> WDB
    Screens --> Hooks
    Hooks --> Engine
    Engine --> WDB
    Sync <--> WDB
    Sync <--> CloudAPI
    BLE <--> Watch
    BLE --> WDB
```

### 2.2. Detailed Design

#### 2.2.1. Navigation Structure
Based on the PRD, we will use `react-navigation` with a Bottom Tab Navigator as the root.

*   **Tab 1: Today (Dashboard)**
    *   **Components:** `BodySystemScan`, `DailyDirective`, `FuelingCard`.
    *   **Data Source:** Observes `DailyMetrics` and today's `Workout` from DB.
*   **Tab 2: Plan (Calendar)**
    *   **Components:** `CalendarView` (Agenda/Month), `WorkoutDetail`.
    *   **Data Source:** Observes `TrainingPlan` and `Workout` collections.
*   **Tab 3: Progress (Analytics)**
    *   **Components:** `ACWRChart`, `TSBChart`, `PersonalBests`.
    *   **Data Source:** Aggregated queries from `Activities` and `DailyMetrics`.
*   **Tab 4: Library (Resources)**
    *   **Components:** `ResourceList`, `VideoPlayer`.
    *   **Data Source:** Cached content from CMS/S3.
*   **Tab 5: You (Profile)**
    *   **Components:** `Settings`, `DeviceManager`, `Subscription`.

#### 2.2.2. The "Body System Scan" Implementation
The "Body System Scan" is the core UI element. It requires real-time calculation based on multiple inputs.

1.  **Inputs:** Sleep (HealthKit), HRV (HealthKit/Watch), Soreness (User Input), Load (DB History).
2.  **Processing:**
    *   User inputs data via `MorningCheckIn` modal.
    *   `@runningcoach/engine` runs `assessReadiness(inputs)`.
    *   Result is saved to `DailyMetrics` table.
3.  **Visualization:**
    *   The Dashboard observes the `DailyMetrics` record for the current day.
    *   SVG overlay on a body silhouette changes color (Green/Yellow/Red) based on the observed data.

#### 2.2.3. Data Layer (WatermelonDB)
We use WatermelonDB for its lazy-loading and observable capabilities, essential for performance with large datasets (e.g., years of workout history).

**Key Models:**
*   **User:** `id`, `name`, `vo2max`, `preferences` (JSON).
*   **Goal:** `id`, `user_id`, `race_date`, `target_time`, `distance`, `status`.
*   **TrainingPlan:** `id`, `start_date`, `end_date`, `goal_id`.
*   **Workout:** `id`, `plan_id`, `date`, `type`, `structure` (JSON), `completed` (bool).
*   **Activity:** `id`, `workout_id`, `timestamp`, `duration`, `distance`, `metrics` (JSON - HR, Pace).
*   **DailyMetric:** `id`, `date`, `sleep_score`, `hrv`, `soreness_map` (JSON), `readiness_score`.
*   **InjuryReport:** `id`, `user_id`, `date`, `location`, `intensity`, `status`.
*   **NutritionLog:** `id`, `user_id`, `date`, `carbs`, `protein`, `fat`, `notes` (JSON).
*   **Resource:** `id`, `category`, `title`, `type` (video/article), `content_url`, `duration`.
*   **SyncQueue:** `id`, `table`, `record_id`, `action`, `timestamp`.

> [!NOTE]
> All models include sync metadata fields as defined in RFC 0001 (Section 2.3): `_id` (local ID), `id` (server UUID), `_status` ('synced'|'created'|'updated'|'deleted'), `_changed` (timestamp), and `last_synced_at`.

#### 2.2.4. HealthKit & Health Data Integration

HealthKit (iOS) and Health Connect (Android) are critical data sources for the "Holistic Coach" experience, providing sleep, HRV, resting heart rate, and workout data.

**Required Permissions:**
*   **Sleep Analysis** - For sleep quality and duration
*   **Heart Rate Variability** - For autonomic nervous system readiness
*   **Resting Heart Rate** - For cardiovascular fatigue tracking
*   **Workouts** - To import Apple Watch workouts automatically
*   **Active Energy** - For cross-training activity tracking

**Data Import Strategy:**
1.  **Initial Import:** On first launch after permission grant, import last 90 days of sleep and HRV data
2.  **Ongoing Sync:** Use HealthKit background delivery to receive new data automatically
3.  **Deduplication:** Query HealthKit for workouts and match against existing Watch app activities by timestamp and duration to avoid duplicates

**Implementation:**
*   **Library:** `@kingstinct/react-native-healthkit` for iOS, `react-native-health-connect` for Android
*   **Background Delivery:** Register observer queries for Sleep, HRV, Workouts to receive updates when app is backgrounded
*   **Data Flow:** HealthKit → Parse → DailyMetrics table → Trigger `assessReadiness()` if current day data changes

**Privacy Considerations:**
*   Health data never leaves the device without user consent
*   Data is used only for coaching calculations, not sold or shared
*   User can revoke permissions at any time via iOS Settings

#### 2.2.5. Critical User Flows

These flows are specified in the Mobile Client PRD but require detailed implementation guidance.

**Flow 1: Morning Check-In (PRD 5.1)**
*   **Trigger:** Local notification at 7:00 AM (user-configurable)
*   **UI:** Modal overlay with three inputs:
    1.  Sleep Quality slider (1-10) with emoji feedback
    2.  Soreness Map - tap body diagram to mark sore areas, intensity per area (1-3)
    3.  Stress Level slider (1-10)
*   **Data Flow:**
    ```typescript
    // User submits check-in
    const inputs = { sleepQuality, sorenessMap, stressLevel, hrv: fromHealthKit, restingHR: fromHealthKit };
    const readinessScores = await engine.assessReadiness(inputs);
    await database.write(async () => {
      await dailyMetricsCollection.create(record => {
        record.date = today;
        record.sleep_quality = sleepQuality;
        record.soreness_json = JSON.stringify(sorenessMap);
        record.cns_status = readinessScores.cns;
        record.muscular_status = readinessScores.muscular;
        record.skeletal_status = readinessScores.skeletal;
        record.cardio_status = readinessScores.cardio;
        record.overall_readiness = readinessScores.overall;
      });
    });
    // Dashboard auto-updates via observable
    ```

**Flow 2: Injury Reporting (PRD 5.3)**
*   **Entry Points:** "Report Pain" button on Dashboard, "I'm Injured" in Plan tab "Life Happens" menu
*   **UI:** Two-step process:
    1.  Select body part from visual diagram (same as soreness map)
    2.  Rate pain intensity (1-10) and type (sharp/dull/ache)
*   **Immediate Action:**
    ```typescript
    // Save injury
    await injuryReportsCollection.create(record => {
      record.location = bodyPart;
      record.intensity = painLevel;
      record.status = 'active';
    });
    // Trigger plan adaptation
    const updatedPlan = await engine.adaptPlanForInjury(currentPlan, injury);
    // Replace high-impact workouts with low-impact alternatives
    ```
*   **Plan Adaptation:** System immediately modifies upcoming workouts:
    *   Lower body injury → Replace runs with pool running or cycling
    *   Upper body injury → Continue running but remove strength sessions

**Flow 3: "Life Happens" Actions (PRD 4.2)**
*   **UI:** Button in Plan tab header, opens action sheet with:
    *   "I'm Sick" 🤒
    *   "I'm Traveling" ✈️
    *   "I'm Tired" 😴
*   **Logic:**
    *   **"I'm Sick":** Trigger RFC 0001's "Return to Health" protocol - clear next 3 days, resume with easy runs
    *   **"I'm Traveling":** Offer "Maintenance Mode" - shorten workouts, increase intensity to maintain fitness
    *   **"I'm Tired":** Reduce this week's volume by 20%, shift long run to recovery run
*   **Warning System:** If user manually drags a workout to a different day, calculate new ACWR. If > 1.5 (danger zone), show alert:
    > ⚠️ "Moving this workout increases your injury risk to HIGH. Consider keeping the original schedule."

**Flow 4: Post-Workout RPE (PRD 5.2)**
*   **Trigger:** Automatic modal appears 5 minutes after workout is marked complete
*   **UI:** Single question: "How hard was that?" with RPE scale (1-10) and Borg descriptors
*   **Data Flow:**
    ```typescript
    await activityRecord.update(activity => {
      activity.rpe = rpeValue;
    });
    // Update fatigue scores based on RPE mismatch with planned intensity
    const expectedRPE = workout.structure.targetRPE;
    if (rpeValue > expectedRPE + 2) {
      // Workout was much harder than planned - increase muscular fatigue
      await updateFatigueScores({ muscular: +0.5, cns: +0.3 });
    }
    ```

#### 2.2.6. Synchronization Strategy

**Cloud Sync:**
*   **Protocol:** Delta Sync via tRPC (as defined in RFC 0001 Section 2.4.1).
*   **Trigger:** App foreground, network regain, manual pull-to-refresh.
*   **Mechanism:** `SyncAdapter` pulls changes > `last_pulled_at` and pushes local `SyncQueue`.
*   **Implementation:** Custom WatermelonDB Sync Adapter integrated with tRPC client.

**Watch Sync (BLE):**
*   **Library:** `react-native-ble-plx` for cross-platform BLE communication.
*   **Connection Management:**
    *   Pairing flow triggered from "Pair Watch" button on Dashboard
    *   Auto-reconnection when watch comes in range (background scanning)
    *   Connection state exposed via Zustand store for UI indicators
*   **Pre-Run Sync (Phone → Watch):**
    *   **Trigger:** Morning (6:00 AM automatic sync), or when watch app opened manually
    *   **Context Pack Structure:**
        ```json
        {
          "workouts": [
            {
              "date": "2025-11-27",
              "type": "threshold",
              "structure": { "warmup": 10, "intervals": [{ "duration": 5, "pace": "4:30/km" }] },
              "zones": { "hr": [140, 160], "pace": ["4:20/km", "4:40/km"] }
            }
          ],
          "userZones": { "hrMax": 185, "zones": [/* ... */] },
          "engineVersion": "1.2.3"
        }
        ```
    *   **Transfer Size:** ~50-200 KB compressed JSON
    *   **UI:** Progress indicator showing "Syncing workout plan to watch..."
*   **Post-Run Sync (Watch → Phone):**
    *   **Trigger:** Workout completed on watch, phone reconnects
    *   **Activity Pack Structure:**
        ```json
        {
          "workoutId": "uuid",
          "startTime": 1732654800,
          "duration": 3600,
          "distance": 15000,
          "samples": [ /* HR, Pace, GPS per second */ ],
          "summary": { "avgHR": 155, "maxHR": 178, "avgPace": "4:45/km" },
          "rpe": 7,
          "fitFileUrl": "blob://..." // Optional FIT file
        }
        ```
    *   **Transfer Size:** 500 KB - 5 MB depending on workout length
    *   **Handling:** Phone validates, saves to `Activity` table, triggers sync to cloud
    *   **Error Handling:** If transfer interrupted, watch retains data and retries on next connection

#### 2.2.7. Logic Engine OTA Updates

As defined in RFC 0001 (Section 2.2.5), the Adaptive Training Engine can be updated without App Store releases.

**Version Check Mechanism:**
*   **Trigger:** App launch, daily background fetch (iOS Background App Refresh)
*   **Endpoint:** `logic.getLatestVersion()` tRPC call returns `{ version: "1.3.0", downloadUrl: "..." }`
*   **Comparison:** Compare server version with local `AsyncStorage.get('logicEngineVersion')`

**Download Strategy:**
*   If `remote > local`, download bundle from S3 via CloudFront CDN
*   **Bundle Format:** Minified JavaScript bundle (~500 KB)
*   **Download:** Use `expo-file-system` with retry logic (max 3 attempts)
*   **Validation:** Verify SHA-256 checksum before installation

**Hot Swap Implementation:**
*   **Method 1 (Preferred):** Use EAS Update to push new bundle over-the-air
    *   Bundle includes both app code AND logic engine
    *   App auto-reloads on next launch or via `Updates.reloadAsync()`
*   **Method 2 (Fallback):** Dynamic `require()` for logic bundle
    *   Load downloaded bundle via `eval()` or `new Function()` (only in dev mode)
    *   Production uses pre-compiled bundle from EAS Update

**Rollback Safety:**
*   **Crash Detection:** If app crashes within 30 seconds of logic update, rollback to previous version
*   **Version Pinning:** Store last 2 logic versions locally, allow manual rollback in settings (dev mode)
*   **Error Reporting:** Send crash logs with logic version to Sentry for analysis

**User Communication:**
*   **Silent Updates:** Logic updates happen silently in background (aligns with "seamless coach" philosophy)
*   **No Notifications:** Avoid disrupting user experience
*   **Changelog:** Optional "What's New" in settings for curious users

### 2.3. Data Model Changes
(Refining the schema for Mobile specifics)

**Schema Definition (`schema.ts`):**
```typescript
tableSchema({
  name: 'daily_metrics',
  columns: [
    { name: 'date', type: 'number' }, // Unix timestamp
    { name: 'sleep_quality', type: 'number' },
    { name: 'hrv_value', type: 'number' },
    { name: 'soreness_json', type: 'string' }, // Serialized map
    { name: 'cns_status', type: 'string' },
    { name: 'muscular_status', type: 'string' },
    { name: 'skeletal_status', type: 'string' },
    { name: 'cardio_status', type: 'string' },
    { name: 'overall_readiness', type: 'number' },
  ]
})
```

### 2.4. API Changes
The mobile app will primarily consume the tRPC routers defined in RFC 0001.
*   **New Hook:** `useSync()` - Encapsulates the sync logic and exposes status (`syncing`, `offline`, `error`).
*   **New Hook:** `useBrain()` - Exposes the local logic engine functions (`generatePlan`, `assessReadiness`).

### 2.5. Offline-First Considerations
*   **Optimistic UI:** All user actions (e.g., completing a workout, changing a setting) apply immediately to the local DB. The UI updates instantly. The sync happens in the background.
*   **Conflict Resolution:**
    *   **Subjective Data (RPE, Notes):** Last write wins (Client usually authoritative).
    *   **Objective Data (GPS):** Merged, preferring higher fidelity source.

### 2.6. UI/UX & Design System
*   **Theme:** Centralized `ThemeContext` providing colors (Medical White, Signal Green, Alert Red) and typography (Swiss style).
*   **Components:** Atomic design pattern.
    *   `GlassCard`: Base component for dashboard items with blur effect.
    *   `StatusIndicator`: Reusable traffic light dot.
    *   `MetricGraph`: Wrapper around Victory Native charts.

### 2.7. Cross-Platform Considerations

The mobile app is part of a multi-platform ecosystem including web (Next.js) and watches. Alignment is critical to avoid divergent implementations.

**Shared Logic Layer:**
*   The `@runningcoach/engine` TypeScript package runs identically on mobile (Hermes), web (browser JS), and Apple Watch (JSC)
*   Engine API must remain platform-agnostic - no React Native-specific dependencies
*   Version synchronization: Mobile, web, and watch must support the same engine version range

**API Contract Consistency:**
*   Mobile uses the same tRPC endpoints as web (defined in RFC 0001)
*   No mobile-specific API endpoints unless absolutely necessary
*   Request/response schemas validated with Zod on both client and server

**Design System Alignment:**
*   **Shared Tokens:** Color palette, typography scale, spacing system defined in central `design-tokens` package
*   **Component Parity:** Dashboard cards (Body System Scan, Fueling) should have equivalent web implementations
*   **Icon Library:** Use `@expo/vector-icons` on mobile, matching icon set on web (e.g., Heroicons)

**State Management Patterns:**
*   Both mobile and web use Zustand for global UI state
*   State shape should be consistent (e.g., `AuthState`, `SyncState`)
*   Allows for potential code sharing in future monorepo architecture

**Data Model Consistency:**
*   WatermelonDB schema (mobile) mirrors PostgreSQL schema (backend) and IndexedDB schema (web)
*   Sync metadata format identical across all platforms
*   Field naming convention: snake_case for database columns, camelCase for TypeScript objects

**Preventing Platform Drift:**
*   Shared repository with `packages/engine`, `packages/design-tokens`, `packages/types`
*   CI pipeline runs tests against shared packages on every PR
*   Monthly cross-platform sync meeting to review divergence

## 3. Implementation Plan

### 3.1. Phasing

**Phase 1: Foundation (Weeks 1-2)**
*   Initialize Expo project with TypeScript.
*   Setup Navigation (Tabs + Stacks).
*   Configure WatermelonDB and Schema.
*   Implement basic Auth screens (Login/Register).

**Phase 2: Core UI & Data (Weeks 3-6)**
*   Implement "Today" Dashboard (UI only).
*   Implement "Plan" Calendar (UI only).
*   Connect UI to WatermelonDB (CRUD operations).
*   Implement "Body System Scan" visualization.

**Phase 3: The Brain & Logic (Weeks 7-9)**
*   **Dependencies:** ⚠️ RFC 0001 Phase 2 (Shared Brain) must be complete - requires `@runningcoach/engine` package
*   Integrate `@runningcoach/engine` package.
*   Implement `MorningCheckIn` flow connecting to Engine.
*   Implement Plan Generation flow locally.
*   Implement Injury Reporting and "Life Happens" flows (PRD requirements).

**Phase 4: Sync & Integrations (Weeks 10-12)**
*   **Dependencies:** ⚠️ RFC 0001 Phase 3 (Sync Infrastructure) must be complete - requires tRPC sync endpoints
*   Implement `SyncAdapter` for Cloud sync.
*   Implement HealthKit integration for auto-importing sleep/workouts.
*   Basic BLE connectivity testing.
*   Implement Logic Engine OTA update mechanism.

**Phase 5: Polish & Performance (Weeks 13-14)**
*   Animation refinement (Reanimated).
*   Performance profiling (FlashList optimization).
*   Offline edge case testing.

### 3.2. Testing Strategy
*   **Unit Tests:** Jest for utility functions and hooks.
*   **Component Tests:** React Native Testing Library for UI components.
*   **E2E Tests:** Maestro or Detox for critical flows (Onboarding -> Plan Generation -> Workout Logging).
*   **Manual:** "Airplane Mode" testing to verify offline capabilities.

**Offline/Online Transition Tests:**
*   Verify data integrity when network drops mid-sync
*   Test queued operations execute correctly when reconnected
*   Simulate multi-device conflict scenarios and verify resolution
*   Test app behavior when coming online after extended offline period

### 3.3. Migration Strategy

**Initial Deployment:**
*   No existing users for initial release; fresh WatermelonDB schema deployment
*   Seed data for development and testing environments

**Future Schema Evolution:**
*   **WatermelonDB Migrations:** Use `schemaMigrations` API for local schema changes
*   **Migration Versioning:** Schema version tracked in `AsyncStorage`, migrations run on app launch
*   **Data Preservation:** Migrations preserve user data; destructive changes require explicit handling
*   **Backward Compatibility:** Support syncing with N-1 backend schema version for 30 days

**Logic Bundle Updates:**
*   EAS Update for app code + logic engine bundle
*   Versioned bundles with checksum validation
*   Automatic rollback on crash detection

**Rollout Plan:**
*   **Alpha:** Internal team testing (10 users)
*   **Beta:** TestFlight / Google Play Beta (100 users)
*   **Soft Launch:** Limited regions via App Store
*   **Full Launch:** Global availability

### 3.4. Rollback Strategy

**Rollback Triggers:**
*   Crash rate > 1% for new version
*   Sync failures > 10%
*   Critical bug reported by > 5 users
*   Logic engine errors affecting training recommendations

**Rollback Procedure:**

**App Code Rollback:**
1.  Publish previous EAS Update bundle (immediate for Expo, ~15 min propagation)
2.  If native code changed, submit hotfix to App Store / Google Play
3.  Notify affected users via in-app message or push notification

**Database Rollback:**
1.  Down-migrations not always possible; prefer forward-compatible changes
2.  If needed, export user data, reset database, re-import
3.  Last resort: full re-sync from cloud (user's data preserved server-side)

**Logic Engine Rollback:**
1.  Update `logic.getLatestVersion()` to return previous stable version
2.  Devices auto-download previous bundle on next version check
3.  Crash detection triggers automatic local rollback to cached previous version

**User Impact Mitigation:**
*   All data queued locally; no data loss during rollback
*   App remains functional offline during transition
*   Clear communication via app banner for known issues

## 4. Alternatives Considered

| Alternative | Pros | Cons | Reason for Rejection |
|------------|------|------|---------------------|
| **Flutter** | High performance, consistent rendering | Dart language barrier, harder to share logic with Web/Backend | We need to share the TypeScript "Brain" across all platforms. |
| **Redux** | Industry standard, robust debugging | High boilerplate, complex for simple state | Zustand is lighter and sufficient; WatermelonDB handles the heavy data state. |
| **Realm** | Built-in sync, fast | Large binary size, proprietary sync | WatermelonDB allows custom backend sync logic which we need for our specific architecture. |

## 5. Cross-Cutting Concerns

### 5.1. Security

Security implementation aligns with RFC 0001 (Section 5.1) with mobile-specific considerations.

**Authentication & Token Management:**
*   **Provider:** Supabase Auth (JWT-based)
*   **Token Storage:** Access tokens and refresh tokens stored in `Expo SecureStore` (iOS Keychain / Android Keystore)
*   **Token Lifecycle:**
    *   Access tokens: 15-minute expiry
    *   Refresh tokens: 30-day expiry
    *   Automatic refresh handled by tRPC middleware before expiry
*   **Biometric Auth:** Optional FaceID/TouchID for app entry (reduces need to re-enter password)

**Data Protection:**
*   **At Rest:**
    *   Health data (sleep, HRV) never synced to cloud without explicit user consent
    *   WatermelonDB local database uses OS-level encryption (iOS Data Protection, Android File-Based Encryption)
    *   Sensitive fields (e.g., notes with personal info) can be application-level encrypted if needed
*   **In Transit:**
    *   All API calls use TLS 1.3
    *   Certificate pinning enabled to prevent man-in-the-middle attacks
    *   BLE connections encrypted at Bluetooth protocol level

**Privacy Compliance:**
*   **GDPR "Right to Erasure":** User can delete account and all data via settings
*   **Data Export:** User can export all training data as JSON for portability
*   **HealthKit Privacy:** Health data used ONLY for coaching calculations, never shared with third parties
*   **Minimal Analytics:** PostHog used with privacy mode (no PII tracked)

**Threat Mitigation:**
*   **Device Theft:** Short JWT expiry limits unauthorized access; biometric lock available
*   **Malicious Logic Bundles:** SHA-256 checksum validation before loading OTA updates
*   **SQL Injection:** WatermelonDB uses parameterized queries; no raw SQL from user input

### 5.2. Performance
*   **Lists:** Use `FlashList` (Shopify) instead of `FlatList` for calendar and history lists.
*   **Images:** Use `expo-image` for caching and performance.
*   **Bundling:** Hermes engine enabled for faster startup and smaller bundle size.

### 5.3. Observability
*   **Crash Reporting:** Sentry for React Native.
*   **Analytics:** PostHog (privacy-focused) for feature usage tracking.
*   **Logs:** `expo-logger` for development debugging.

### 5.4. Reliability

**Error Handling:**
*   **Error Boundaries:** Wrap feature modules in React Error Boundaries to prevent full app crashes
*   **Graceful Degradation:** If Brain fails, show cached readiness; if sync fails, queue and continue
*   **User-Friendly Messages:** Convert technical errors to actionable user guidance
*   **Safe Area:** Handle notches, Dynamic Island, and home indicator gracefully

**Retries:**
*   **Sync Operations:** Exponential backoff (1s, 2s, 4s, 8s, max 16s) with max 5 retries
*   **API Calls:** Automatic retry for transient failures (network errors, 5xx)
*   **BLE Transfers:** Retry interrupted transfers up to 3 times before notifying user

**Data Integrity:**
*   **Validation:** Zod schemas validate all data entering the app
*   **Database Constraints:** WatermelonDB enforces type safety at model level
*   **Checksum Verification:** FIT files and logic bundles validated before processing
*   **Transaction Safety:** Multi-record updates wrapped in database transactions

**Disaster Recovery:**
*   **Local Backup:** Critical data (current plan, recent activities) cached in multiple locations
*   **Cloud Recovery:** Full user data recoverable from server; re-sync on new device
*   **Export Capability:** User can export all data as JSON via settings
*   **Corrupted Database:** Detection and automatic re-sync from cloud with user notification

## 6. Stakeholder Review

| Stakeholder | Role | Review Status | Sign-off Date |
|------------|------|---------------|---------------|
| Maksat | Product Owner | Pending | |
| System Architect | Tech Lead | Pending | |

## 7. Open Questions
*   **Background Fetch:** How frequently can we reliably sync in the background on iOS without silent push notifications? (Constraint: iOS limits background tasks).
*   **Map Provider:** Google Maps vs. Mapbox for workout visualization? (Decision: Mapbox for better customization, or `react-native-maps` with Apple Maps/Google Maps for cost efficiency).

## 8. References
*   [React Native Documentation](https://reactnative.dev/)
*   [WatermelonDB Documentation](https://github.com/Nozbe/WatermelonDB)
*   [Expo Documentation](https://docs.expo.dev/)
