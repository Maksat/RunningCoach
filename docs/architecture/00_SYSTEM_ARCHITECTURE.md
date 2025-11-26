# System Architecture

## 1. Executive Summary

The RunningCoach architecture is designed as a **distributed, offline-first system** spanning three nodes: the **Cloud Backend**, the **Mobile App (Phone)**, and the **Watch App (Wearable)**.

**Key Architectural Decisions:**
1.  **Distributed "Brain":** The core Adaptive Training Engine is a portable module that runs locally on the Phone (and potentially the Watch) to ensure zero-latency guidance and offline capability.
2.  **Dynamic Logic Updates:** The training algorithms are decoupled from the app binary, allowing Over-The-Air (OTA) updates of the "Brain" logic without requiring App Store releases.
3.  **Thick Client Watch:** The Watch app is a standalone "Thick Client" with its own local database, capable of fully managing a run and providing guidance even without the phone.
4.  **Eventual Consistency:** The system embraces eventual consistency, with the Cloud acting as the ultimate convergence point for data, but the local device acting as the immediate source of truth for the user.

---

## 2. High-Level Topology

```mermaid
graph TD
    subgraph Cloud ["Cloud Backend (The Archive & Heavy Lift)"]
        API[API Gateway]
        DB[(Primary DB)]
        Logic_Repo[Logic Repository]
        Ext_Svcs[External Integrations]
    end

    subgraph Phone ["Mobile App (The Primary Brain)"]
        Phone_UI[UI Layer]
        Phone_DB[(Local DB)]
        Phone_Brain[Shared Logic Engine]
        Phone_Sync[Sync Manager]
    end

    subgraph Watch ["Watch App (The Field Companion)"]
        Watch_UI[UI Layer]
        Watch_DB[(Local DB)]
        Watch_Brain[Shared Logic Engine (Lite)]
        Watch_Sync[Sync Manager]
    end

    Phone_Sync <-->|HTTPS / Delta Sync| API
    Watch_Sync <-->|BLE / File Transfer| Phone_Sync
    Watch_Sync -.->|WiFi / LTE (Optional)| API

    Phone_Brain --> Phone_DB
    Watch_Brain --> Watch_DB
    
    Logic_Repo -.->|OTA Update| Phone_Brain
    Phone_Brain -.->|Sync Logic| Watch_Brain
```

---

## 3. The "Shared Brain" (Dynamic Adaptive Engine)

To meet the requirement of **local availability** with **seamless updates**, the Adaptive Training Engine is architected as a **Portable Logic Module**.

### 3.1. Architecture
*   **Format:** The core logic (training plan generation, readiness assessment, workout adjustments) is written as a **TypeScript Bundle**, compiled to JavaScript and executed by embedded JS engines.
*   **Execution Environment:**
    *   **Phone (React Native):** Hermes JS Engine
    *   **Apple Watch (WatchOS):** JavaScriptCore (JSC)
    *   **Garmin Watch (ConnectIQ):** Custom transpiled MonkeyC (see section 6.2)
*   **Execution Scope:**
    *   **Phone:** Runs the full engine. Generates complete training plans, recalculates all metrics, performs deep analysis.
    *   **Watch:** Runs a "Lite" version focused on real-time workout adjustment logic (e.g., "HR too high, slow down", zone guidance).

### 3.2. Dynamic Update Mechanism (Hot Code Push)
1.  **Versioning:** Each logic bundle has a semantic version (e.g., `v1.2.4`).
2.  **Distribution:** The Cloud hosts the latest logic bundles.
3.  **Update Flow:**
    *   App launch / Background check: Phone checks Cloud for `latest_logic_version`.
    *   If `remote > local`: Phone downloads the new bundle.
    *   **Hot Swap:** The app reloads the logic module immediately (or on next restart).
    *   **Watch Propagate:** Phone pushes the compatible logic bundle to the Watch via BLE.
4.  **Safety:**
    *   Rollback capability if the new logic crashes.
    *   Signature verification to prevent tampering.

---

## 4. Data Synchronization Strategy

### 4.1. Cloud <-> Phone (The "Mothership" Link)
*   **Protocol:** **Delta Sync** (only changes are transferred).
*   **Conflict Resolution:**
    *   **Objective Data (GPS, HR):** Union/Merge. High-fidelity data (e.g., from Watch) overwrites low-fidelity data.
    *   **Subjective Data (RPE, Notes):** Client wins (Last Write Wins).
    *   **Training Plan:** Server (or "Brain") wins. If the algorithm updates the plan, it supersedes manual user scheduling conflicts.
*   **Technology:** **WatermelonDB** with custom Sync Adapter for React Native. Provides lazy-loading, observables, and full control over delta sync implementation.

### 4.2. Phone <-> Watch (The "Field" Link)
*   **Challenge:** BLE bandwidth is low; connectivity is intermittent.
*   **Strategy:**
    *   **Pre-Run (Phone -> Watch):** Sync "Context Pack" (Next 3 days of workouts, User Zones, Logic Bundle).
    *   **Post-Run (Watch -> Phone):** Sync "Activity Pack" (FIT file/JSON of the run, RPE, Metrics).
*   **Standalone Mode:**
    *   The Watch **MUST** have its own local database (e.g., SQLite/Realm).
    *   It does **NOT** query the phone for data during a run.
    *   It records to its local DB. Sync happens when the connection is restored.

---

## 5. Offline-First Scenarios

### 5.1. Scenario: "The Disconnected Runner" (Phone Only, No Internet)
1.  **App Open:** Loads data from `Local DB`. No spinner, no "connecting...".
2.  **Plan View:** Shows the plan generated by the *local* "Brain" using the last known data.
3.  **Action:** User logs a run or checks off a workout.
4.  **Processing:** The "Brain" runs locally, updates the `Body State` (e.g., increases fatigue), and adapts tomorrow's workout.
5.  **Sync:** Changes are queued. When internet returns, data is pushed to Cloud.

### 5.2. Scenario: "The Minimalist" (Watch Only, No Phone)
1.  **Preparation:** Watch synced with Phone earlier (e.g., morning sync). Has `Workout Structure` and `User Zones`.
2.  **The Run:**
    *   User starts "Threshold Run".
    *   Watch provides guidance (audio/haptic) based on locally stored zones.
    *   Real-time logic: "Pace is 10s too fast, slow down."
3.  **Post-Run:**
    *   Run saved to Watch `Local DB`.
    *   Summary screen shown on Watch.
4.  **Reunion:**
    *   User gets back to Phone.
    *   Watch <-> Phone sync triggers.
    *   Phone receives run data -> Phone "Brain" recalculates readiness -> Phone updates Plan -> Cloud Sync.

### 5.3. Scenario: "The Dead Phone" (Cloud Recovery)
1.  **Situation:** Phone breaks. User gets a new one.
2.  **Restore:** User logs in.
3.  **Hydration:** App pulls full history and latest state from Cloud.
4.  **Resume:** User picks up exactly where they left off.

---

## 6. Technology Stack (Definitive Choices)

### 6.1. Mobile App (iOS & Android)

| Component | Technology | Details |
| :--- | :--- | :--- |
| **Framework** | **React Native** | Cross-platform development with native performance |
| **UI Library** | **React Native Paper** + Custom Components | Material Design baseline with custom coaching-focused components |
| **State Management** | **Zustand** | Lightweight, minimal boilerplate |
| **Local Database** | **WatermelonDB** | SQLite-based, lazy-loading, optimized for React Native |
| **JS Engine** | **Hermes** | Optimized for React Native, runs TypeScript logic bundle |
| **Navigation** | **React Navigation** | Standard for React Native apps |
| **Charts/Visualization** | **Victory Native** | Performance-focused charting library |

### 6.2. Watch Apps (Platform-Specific)

#### Apple Watch (WatchOS)
| Component | Technology | Details |
| :--- | :--- | :--- |
| **Framework** | **SwiftUI** (WatchOS SDK) | Native WatchOS development |
| **Local Database** | **SQLite** (via GRDB.swift) | Lightweight, proven on WatchOS |
| **Logic Engine** | **JavaScriptCore (JSC)** | Runs TypeScript-compiled JavaScript bundles |
| **Sync Protocol** | **Watch Connectivity Framework** | BLE sync with iPhone |

#### Garmin Watch (ConnectIQ)
| Component | Technology | Details |
| :--- | :--- | :--- |
| **Framework** | **MonkeyC** (ConnectIQ SDK) | Garmin's proprietary language |
| **Local Database** | **Object Store API** | ConnectIQ's native storage |
| **Logic Engine** | **Transpiled MonkeyC** | TypeScript → MonkeyC via custom transpiler (subset of features) |
| **Sync Protocol** | **Garmin Mobile SDK** | BLE sync with mobile app |

> [!NOTE]
> For Garmin watches, a **TypeScript-to-MonkeyC transpiler** will be developed to convert core logic rules into MonkeyC. This will support a subset of the full engine focused on real-time workout adjustments.

### 6.3. Web Platform

| Component | Technology | Details |
| :--- | :--- | :--- |
| **Framework** | **Next.js 14** (App Router) | React framework with SSR/SSG support |
| **UI Library** | **Shadcn/ui** + **Tailwind CSS** | Modern, accessible component library |
| **State Management** | **Zustand** | Consistent with mobile app |
| **Database Client** | **IndexedDB** (via Dexie.js) | Browser-based offline storage |
| **Logic Engine** | **TypeScript Bundle** (same as mobile) | Runs directly in browser |
| **API Communication** | **tRPC** | Type-safe API calls to backend |
| **Charts/Visualization** | **Recharts** | React charting library |

### 6.4. Backend Services

| Component | Technology | Details |
| :--- | :--- | :--- |
| **Runtime** | **Node.js 20 LTS** | JavaScript runtime for consistency with client logic |
| **Framework** | **NestJS** | Enterprise-grade Node.js framework with TypeScript |
| **API Protocol** | **tRPC over HTTP/WebSocket** | Type-safe APIs with real-time capabilities |
| **Primary Database** | **PostgreSQL 16** | ACID compliance, JSON support, proven at scale |
| **Cache Layer** | **Redis 7** | Session management, rate limiting, real-time pub/sub |
| **File Storage** | **AWS S3** (or compatible) | FIT files, profile images, workout recordings |
| **Logic Repository** | **AWS S3** + **CloudFront CDN** | Versioned TypeScript bundles for OTA updates |
| **Task Queue** | **BullMQ** (Redis-based) | Background jobs (sync, notifications, plan generation) |
| **Auth** | **Supabase Auth** | JWT-based authentication with OAuth providers |
| **Hosting** | **AWS ECS** (Fargate) or **Railway** | Container-based deployment |

### 6.5. External Integrations

| Service | Purpose | Integration Method |
| :--- | :--- | :--- |
| **Garmin Connect** | Import historical workouts, export activities | OAuth 2.0 + REST API |
| **Apple HealthKit** | Import health metrics (HRV, sleep, RHR) | HealthKit SDK (iOS only) |
| **Strava** | Export activities, social sync | OAuth 2.0 + REST API |
| **MyFitnessPal** | Nutrition data import | OAuth 2.0 + REST API |
| **Ahotu** | Race database | REST API (race search, registration info) |
| **OpenWeatherMap** | Weather forecasts for training | REST API |

### 6.6. Development & DevOps

| Component | Technology | Details |
| :--- | :--- | :--- |
| **Version Control** | **Git** + **GitHub** | Source control and CI/CD |
| **CI/CD** | **GitHub Actions** | Automated testing, builds, deployments |
| **Mobile Build** | **EAS Build** (Expo) | Cloud builds for iOS/Android |
| **Analytics** | **PostHog** | Privacy-focused product analytics |
| **Error Tracking** | **Sentry** | Real-time error monitoring |
| **Monitoring** | **Grafana** + **Prometheus** | Backend metrics and alerts |

---

## 7. Critical Implementation Path

1.  **Define the "Brain" Interface:** Strictly type the inputs (User History, Body State) and outputs (Training Plan) of the logic engine.
2.  **Build the Portable Module:** Create the `@runningcoach/engine` TypeScript package.
3.  **Implement Mobile DB & Sync:** Set up WatermelonDB and the delta sync loop with backend.
4.  **Watch Integration:** Build standalone Watch data layer for both Apple Watch (SwiftUI + JSC) and Garmin (MonkeyC).
5.  **Web Platform:** Implement Next.js web app with shared TypeScript engine and IndexedDB for offline functionality.
6.  **Backend Infrastructure:** Deploy NestJS backend with PostgreSQL, Redis, and S3-based logic repository.

