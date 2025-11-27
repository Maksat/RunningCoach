# RFC 0001: System Architecture & Technology Stack

| Status        | Accepted |
| :---          | :--- |
| **RFC #**     | 0001 |
| **Author(s)** | System Architect |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
This RFC defines the high-level technical architecture for the RunningCoach application. It translates the vision outlined in [00_OVERARCHING_VISION.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/00_OVERARCHING_VISION.md) and the [System Architecture](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/architecture/00_SYSTEM_ARCHITECTURE.md) into concrete technical decisions.

The RunningCoach application is a holistic, AI-powered training platform that provides adaptive guidance across multiple devices (Phone, Watch, Web) while maintaining full offline functionality.

**Architectural Philosophy:**
The system follows a **hybrid thick-client architecture**:
- **Thick Client (Edge):** The Adaptive Training Engine ("Brain") runs locally on devices for zero-latency guidance, offline functionality, and privacy. This portable TypeScript package executes plan generation, readiness assessment, and real-time workout adjustments.
- **Heavy Backend (Cloud):** The cloud handles long-term data storage, heavy batch computations, external integrations (Garmin, Strava), and serves as the synchronization hub and logic bundle distribution point.

This hybrid approach ensures athletes can train in remote areas without connectivity while still benefiting from cloud-based data aggregation and external service integrations.

### 1.2. Problem Statement
We need a distributed, offline-first system that can provide complex, adaptive training guidance across multiple devices with intermittent connectivity. Key challenges include:

*   **Offline-First Requirement:** Athletes train in environments without reliable internet (trails, remote areas). The system must function fully offline.
*   **Distributed Intelligence:** The adaptive training "Brain" must run locally on edge devices (Phone/Watch) for zero-latency guidance.
*   **Algorithm Updates Without Releases:** Training science evolves. We need to update the core logic without waiting for App Store approval cycles.
*   **Multi-Device Consistency:** A runner's data must be seamlessly available across their watch, phone, and web browser.
*   **Platform Diversity:** Must support iOS, Android, Apple Watch, Garmin watches, and web browsers.

### 1.3. Goals & Non-Goals
**Goals:**
*   **Offline-First:** Full functionality without internet connectivity
*   **Distributed Logic:** The "Brain" (Adaptive Training Engine) runs on the edge (Phone/Watch)
*   **Dynamic Updates:** Training algorithms can be updated Over-The-Air (OTA) without app releases
*   **Platform Agnostic:** Support iOS, Android, Apple Watch, Garmin watches, and Web
*   **Near Real-Time Sync:** When connected, data syncs seamlessly across all devices
*   **Scalable Backend:** Cloud handles heavy processing, data aggregation, and external integrations

**Non-Goals:**
*   Real-time video streaming of workouts (not in MVP scope)
*   Social networking features (handled in separate RFC)
*   Third-party coach marketplace (future consideration)
*   Support for non-running sports in MVP (focused on running only)

### 1.4. Dependencies
**Related PRDs:**
*   [00_OVERARCHING_VISION.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/00_OVERARCHING_VISION.md) - Overall product vision
*   [01_MOBILE_CLIENT.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/01_MOBILE_CLIENT.md) - Mobile app requirements
*   [02_BACKEND_CORE.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/02_BACKEND_CORE.md) - Backend services
*   [03_WEARABLE_INTEGRATION.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/03_WEARABLE_INTEGRATION.md) - Watch integration
*   [05_SYNC_INFRASTRUCTURE.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/05_SYNC_INFRASTRUCTURE.md) - Synchronization requirements
*   [06_ADAPTIVE_TRAINING_ENGINE.md](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/06_ADAPTIVE_TRAINING_ENGINE.md) - Core logic requirements

**Related RFCs:**
*   None (this is the foundational RFC)

**External Dependencies:**
*   **Garmin ConnectIQ SDK** - For Garmin watch app development
*   **Apple WatchOS SDK** - For Apple Watch app development
*   **Supabase Auth** - Authentication service
*   **AWS S3** (or compatible) - Object storage for FIT files, logic bundles, and media
*   **PostgreSQL 16** - Primary database
*   **Redis 7** - Cache and queue infrastructure
*   **Expo/EAS** - React Native build and update infrastructure

### 1.5. Success Metrics
*   **Offline Availability:** 100% of core features functional without internet
*   **Sync Latency:** < 2 seconds for phone ↔ cloud sync when connected
*   **Logic Update Speed:** New "Brain" versions deployed to 90% of active users within 24 hours
*   **Data Consistency:** Zero data loss during sync conflicts
*   **Watch Battery Impact:** < 5% additional battery drain per hour of workout
*   **App Launch Time:** < 2 seconds cold start (with cached data)
*   **Cross-Device Consistency:** Data available on all devices within 5 seconds of sync

---

## 2. Proposed Solution

### 2.1. High-Level Design

The system consists of three main nodes in a **distributed, offline-first architecture**:

1.  **Cloud Backend:** The "Archive" and heavy computation hub
2.  **Mobile App (Phone):** The "Primary Brain" and user's main interface
3.  **Watch App:** The "Field Companion" for real-time workout guidance

```mermaid
graph TD
    subgraph Cloud ["Cloud Backend (The Archive & Heavy Lift)"]
        API[API Gateway - NestJS + tRPC]
        DB[(PostgreSQL - Primary DB)]
        Redis[Redis - Cache/Queue]
        S3[S3 - Logic Repository & File Storage]
        ExtInt[External Integrations]
    end

    subgraph Phone ["Mobile App - React Native (The Primary Brain)"]
        PhoneUI[UI Layer - React Native Paper]
        PhoneDB[(WatermelonDB - Local SQLite)]
        LogicEngine[Adaptive Training Engine - JS Bundle]
        SyncManager[Sync Manager - Delta Sync]
        StateManagement[Zustand State]
    end

    subgraph Watch ["Watch App (The Field Companion)"]
        WatchUI[UI Layer - SwiftUI/MonkeyC]
        LocalDB[(Local DB - SQLite/ObjectStore)]
        LogicLite[Logic Engine Lite - JSC/MonkeyC]
        WatchSync[Sync Manager - BLE]
    end

    Phone <-->|HTTPS / Delta Sync| API
    Watch <-->|BLE / File Transfer| Phone
    Watch -.->|WiFi/LTE (Optional)| API
    
    S3 -.->|OTA Update| LogicEngine
    LogicEngine -.->|Sync Logic| LogicLite
    
    API <--> DB
    API <--> Redis
    API <--> S3
    API <--> ExtInt
```

**Key Architectural Principles:**
1.  **Distributed "Brain":** The Adaptive Training Engine is a portable TypeScript module that runs locally on devices
2.  **Eventual Consistency:** Local device is the immediate source of truth; Cloud is the convergence point
3.  **Thick Client Watch:** Watch app is fully standalone with its own database
4.  **Dynamic Logic Updates:** Training algorithms decouple from app binary for OTA updates

### 2.2. Detailed Design

#### 2.2.1. Cloud Backend (The Archive & Heavy Lift)

**Purpose:** Long-term data storage, heavy computation, external integrations, and logic distribution.

**Technology Stack:**
*   **Runtime:** Node.js 20 LTS
*   **Framework:** NestJS (Enterprise TypeScript framework)
*   **API Protocol:** tRPC over HTTP/WebSocket (type-safe APIs with real-time capabilities)
*   **Database:** PostgreSQL 16 (ACID compliance, JSON support, proven at scale)
*   **Cache/Queue:** Redis 7 (session management, rate limiting, BullMQ job queue)
*   **File Storage:** AWS S3 + CloudFront CDN (FIT files, profile images, logic bundles)
*   **Auth:** Supabase Auth (JWT-based with OAuth providers)
*   **Hosting:** AWS ECS (Fargate) or Railway (container-based deployment)

**Key Responsibilities:**
*   Store complete user history and training data
*   Host versioned training logic bundles for OTA distribution
*   Run batch processing jobs (e.g., weekly plan generation for all users)
*   Integrate with external services (Garmin Connect, Strava, MyFitnessPal, weather APIs)
*   Provide web app API endpoints

**API Architecture:**
*   **tRPC Endpoints:** Type-safe procedures for mobile/web clients
*   **REST Endpoints:** Webhooks for external integrations (Garmin, Strava)
*   **WebSocket:** Real-time sync notifications when data changes

#### 2.2.2. Mobile App (The Primary Brain)

**Purpose:** Main user interface, runs full Adaptive Training Engine, orchestrates all data.

**Technology Stack:**
*   **Framework:** React Native (Expo) - Cross-platform for iOS & Android
*   **Language:** TypeScript
*   **UI Library:** React Native Paper (Material Design) + Custom Components
*   **State Management:** Zustand (lightweight, minimal boilerplate)
*   **Local Database:** WatermelonDB (SQLite-based, observable, lazy-loading)
*   **JS Engine:** Hermes (optimized for React Native, executes shared logic bundle)
*   **Navigation:** React Navigation
*   **Charts:** Victory Native (performance-focused charting)
*   **Build/Update:** EAS Build + EAS Update (Expo Application Services)

**Key Responsibilities:**
*   Display all training data, plans, analytics, and insights
*   Run the full Adaptive Training Engine locally
*   Sync with Cloud (delta sync when connected)
*   Sync with Watch via BLE (pre-run context, post-run data)
*   Import data from HealthKit (iOS) and Google Fit (Android)
*   Manage user authentication and profile

**Data Layer:**
*   **WatermelonDB:** Observable database with lazy loading
*   **Collections:** Users, Workouts, TrainingPlans, BodyMetrics, Nutrition, etc.
*   **Sync Adapter:** Custom delta sync implementation with Cloud

#### 2.2.3. Watch Apps (Platform-Specific)

The watch app is a **Thick Client** with its own local database, capable of fully managing a workout without the phone.

##### Apple Watch (WatchOS)

**Technology Stack:**
*   **Framework:** SwiftUI (WatchOS SDK - native development)
*   **Local Database:** SQLite via GRDB.swift (lightweight, proven on WatchOS)
*   **Logic Engine:** JavaScriptCore (JSC) - runs TypeScript-compiled bundles
*   **Sync Protocol:** Watch Connectivity Framework (BLE sync with iPhone)

**Key Features:**
*   Standalone workout execution with real-time guidance
*   Local storage of workout context (next 3 days of plans, user zones)
*   Heart rate zones, pace guidance, interval timers
*   Post-run summary and RPE logging

##### Garmin Watch (ConnectIQ)

**Technology Stack:**
*   **Framework:** MonkeyC (ConnectIQ SDK - Garmin's proprietary language)
*   **Local Database:** Object Store API (ConnectIQ's native storage)
*   **Logic Engine:** Transpiled MonkeyC (TypeScript → MonkeyC via custom transpiler)
*   **Sync Protocol:** Garmin Mobile SDK (BLE sync with mobile app)

> [!NOTE]
> A **TypeScript-to-MonkeyC transpiler** will be developed to convert core logic rules into MonkeyC. This supports a subset of the full engine focused on real-time workout adjustments (e.g., "HR too high, slow down", zone guidance).

**Key Features:**
*   Workout data fields showing real-time metrics
*   Zone-based guidance (audio/visual alerts)
*   FIT file generation and export to Garmin Connect
*   Sync with mobile app for plan context and post-run data upload

#### 2.2.4. Web Platform

**Purpose:** Desktop/laptop access for detailed analytics, plan review, and account management.

**Technology Stack:**
*   **Framework:** Next.js 14 (App Router) - React framework with SSR/SSG
*   **UI Library:** Shadcn/ui + Tailwind CSS (modern, accessible components)
*   **State Management:** Zustand (consistent with mobile)
*   **Database Client:** IndexedDB via Dexie.js (browser-based offline storage)
*   **Logic Engine:** TypeScript Bundle (same as mobile, runs in browser)
*   **API Communication:** tRPC (type-safe calls to backend)
*   **Charts:** Recharts (React charting library)
*   **Hosting:** Vercel or AWS Amplify

**Key Features:**
*   Detailed analytics dashboards with advanced visualizations
*   Training plan calendar view and editing
*   Account settings and subscription management
*   Nutrition and fueling logs
*   Full offline capability via IndexedDB and local logic execution

#### 2.2.5. The Shared Brain (Adaptive Training Engine)

**Architecture:**
The core logic is a **Portable TypeScript Package** (`@runningcoach/engine`) that runs identically across all platforms.

**Format:**
*   Written in TypeScript, compiled to JavaScript bundle
*   Published as versioned NPM package
*   Encapsulates all training plan generation, readiness assessment, and workout adjustment logic

**Execution Environment:**
*   **Phone (React Native):** Hermes JS Engine - runs full engine
*   **Web:** Browser JS Engine (V8/SpiderMonkey) - runs full engine
*   **Apple Watch:** JavaScriptCore (JSC) - runs "Lite" version for workout adjustments
*   **Garmin Watch:** Transpiled to MonkeyC - runs subset of logic for real-time guidance

**Dynamic Update Mechanism (Hot Code Push):**
1.  **Versioning:** Each logic bundle has semantic version (e.g., `v1.2.4`)
2.  **Distribution:** Cloud S3 hosts latest bundles with CloudFront CDN
3.  **Update Flow:**
    *   App checks Cloud for `latest_logic_version` on launch or via background task
    *   If `remote > local`: Download new bundle
    *   **Hot Swap:** App reloads logic module (via EAS Update for React Native, direct load for web)
    *   **Watch Propagate:** Phone pushes compatible bundle to Watch via BLE
4.  **Safety:**
    *   Rollback capability if new logic crashes
    *   Signature verification to prevent tampering
    *   Gradual rollout with feature flags

**Core Modules:**
*   **Plan Generator:** Creates multi-week training plans based on goals and constraints
*   **Readiness Assessor:** Evaluates body system readiness (cardiovascular, muscular, neural)
*   **Workout Adjuster:** Real-time modifications during workouts based on HR, pace, RPE
*   **Load Manager:** Tracks acute/chronic load ratios and prevents overtraining
*   **Nutrition Calculator:** Fueling recommendations based on workout type and duration

### 2.3. Data Model Changes

**Core Entities:**

```typescript
// User Profile
User {
  id: UUID
  email: string
  name: string
  birthDate: Date
  vo2max: number
  zones: HeartRateZones & PaceZones
  goals: Goal[]
  preferences: UserPreferences
}

// Training Plan
TrainingPlan {
  id: UUID
  userId: UUID
  goalId: UUID
  startDate: Date
  endDate: Date
  phase: 'base' | 'build' | 'peak' | 'taper' | 'recovery'
  weeks: Week[]
  adaptationHistory: AdaptationEvent[]
}

// Workout
Workout {
  id: UUID
  planId: UUID
  scheduledDate: Date
  type: 'easy' | 'threshold' | 'intervals' | 'long' | 'recovery' | 'race'
  structure: WorkoutStructure
  completed: boolean
  actualData?: WorkoutData
  rpe?: number
  notes?: string
}

// Activity (Recorded Run)
Activity {
  id: UUID
  userId: UUID
  workoutId?: UUID
  startTime: DateTime
  duration: number
  distance: number
  avgHR: number
  maxHR: number
  avgPace: number
  elevationGain: number
  gpsTrack?: GPSPoint[]
  fitFile?: string (S3 URL)
  source: 'watch_apple' | 'watch_garmin' | 'manual'
}

// Body Metrics
BodyMetrics {
  id: UUID
  userId: UUID
  date: Date
  restingHR: number
  hrv: number
  sleepQuality: number
  muscularFatigue: number
  mentalEnergy: number
  readinessScore: number
}
```

**Sync Metadata:**
Every table includes sync metadata for delta sync:
```typescript
SyncMetadata {
  _id: string (local ID)
  id: UUID (server ID)
  _status: 'synced' | 'created' | 'updated' | 'deleted'
  _changed: string (timestamp)
  last_synced_at: number
}
```

### 2.4. API Changes

**New tRPC Endpoints:**

```typescript
// User & Auth
auth.register(email, password)
auth.login(email, password)
auth.refresh(refreshToken)
user.getProfile()
user.updateProfile(data)

// Training Plans
plan.getCurrent()
plan.getHistory()
plan.create(goalId, preferences)
plan.update(planId, changes)

// Workouts
workout.getUpcoming(days: number)
workout.getHistory(startDate, endDate)
workout.complete(workoutId, data)
workout.log(manualEntry)

// Sync
sync.pull(lastPulledAt: timestamp, schemaVersion: string)
sync.push(changes: Change[], lastPulledAt: timestamp)

// Logic Updates
logic.getLatestVersion()
logic.downloadBundle(version: string)

// External Integrations
integration.connectGarmin(authCode)
integration.connectStrava(authCode)
integration.importActivities(source, startDate, endDate)
```

**REST Endpoints (Webhooks):**
*   `POST /webhooks/garmin` - Receive activity updates from Garmin
*   `POST /webhooks/strava` - Receive activity updates from Strava

**WebSocket Events:**
*   `activity:new` - New activity recorded
*   `plan:updated` - Training plan changed
*   `sync:required` - Server-side data change, trigger client sync

### 2.5. Offline-First Considerations

**Local Storage Strategy:**

| Platform | Storage Mechanism | Database | Capacity |
|----------|------------------|----------|----------|
| **Mobile (React Native)** | WatermelonDB | SQLite | ~100 MB typical, expandable |
| **Web** | IndexedDB (Dexie.js) | IndexedDB | ~50 MB+ (browser dependent) |
| **Apple Watch** | GRDB.swift | SQLite | ~20 MB (optimized for watch) |
| **Garmin Watch** | Object Store API | Native Store | ~2-10 MB (device dependent) |

**Queued Operations:**
*   All mutations (create, update, delete) are immediately applied to local DB
*   Changes are queued in a `sync_queue` table with timestamp and operation type
*   Sync manager processes queue when connection is restored
*   Operations are idempotent to handle retries

**Conflict Resolution:**

| Data Type | Resolution Strategy | Rationale |
|-----------|---------------------|-----------|
| **Objective Data** (GPS, HR, Pace) | Union/Merge - High-fidelity wins | Prefer authoritative source (watch > phone > manual) |
| **Subjective Data** (RPE, Notes) | Client Wins (Last Write Wins) | User's latest input is most accurate |
| **Training Plan** | Server/Brain Wins | Algorithm-generated plan supersedes manual edits |
| **User Profile** | Last Write Wins + Merge | Non-conflicting fields merged, conflicts use latest timestamp |

**Fallback Behavior:**
*   If sync fails after retries, data remains in queue
*   User is notified of sync status in UI (subtle indicator)
*   Critical operations (e.g., plan generation) use locally cached data
*   Periodic background sync attempts continue

**Offline Scenarios Handled:**

1.  **Phone Only, No Internet:**
    *   All features work using local DB and local Brain
    *   Plan generation, workout logging, analytics all functional
    *   Changes queued for later sync

2.  **Watch Only, No Phone:**
    *   Watch has pre-synced workout context (next 3 days of plans, zones)
    *   Full workout execution with guidance
    *   Post-run data stored locally, synced when phone reconnects

3.  **Dead Phone (Device Loss):**
    *   User logs in on new device
    *   Full history pulled from Cloud
    *   Resume exactly where they left off

### 2.6. Synchronization Strategy

#### Cloud ↔ Phone Sync (The "Mothership" Link)

**Protocol:** Delta Sync (only changes transferred)

**Technology:** WatermelonDB custom Sync Adapter with tRPC endpoints

**Sync Flow:**
1.  **Pull Phase:**
    *   Client sends `lastPulledAt` timestamp to server
    *   Server returns all changes since timestamp (inserts, updates, deletes)
    *   Client applies changes to local DB
    *   Update `lastPulledAt`

2.  **Push Phase:**
    *   Client sends all local changes since last sync
    *   Server validates and applies changes
    *   Server returns resolved conflicts or errors
    *   Client updates sync status

**Sync Triggers:**
*   App launch (immediate sync if connected)
*   App returns to foreground
*   Periodic background sync (every 15 minutes when active)
*   User-initiated (pull-to-refresh)
*   After completing a workout

**Data Priority:**
*   Critical: Completed workouts, body metrics → sync immediately
*   High: Training plan changes, user profile updates → sync within minutes
*   Normal: Historical data, notes → sync when convenient

**Conflict Resolution:**
*   Implemented using vector clocks and Last Write Wins (LWW) for most entities
*   Training plan conflicts: server-side Brain regenerates plan considering both changes

#### Phone ↔ Watch Sync (The "Field" Link)

**Challenge:** BLE bandwidth is low (~1-2 Mbps), connectivity is intermittent

**Strategy:** Pre-sync context before workout, post-sync data after workout

**Pre-Run Sync (Phone → Watch):**
*   **Trigger:** Watch app opened or morning sync (automated)
*   **Data:** "Context Pack" containing:
    *   Next 3 days of scheduled workouts (structure, zones, targets)
    *   User's current heart rate zones
    *   User's current pace zones
    *   Latest Logic Engine Lite bundle (if updated)
*   **Protocol:** BLE file transfer via Watch Connectivity Framework (Apple) or Garmin Mobile SDK
*   **Size:** ~50-200 KB compressed JSON + logic bundle (~500 KB, transferred only on updates)

**Post-Run Sync (Watch → Phone):**
*   **Trigger:** Workout completed, phone in range
*   **Data:** "Activity Pack" containing:
    *   FIT file or JSON with full workout data (GPS, HR, pace per second)
    *   User-entered RPE
    *   Summary metrics
*   **Protocol:** BLE file transfer
*   **Size:** ~500 KB - 5 MB depending on workout length and GPS resolution

**Standalone Watch Mode:**
*   Watch does NOT query phone during workout
*   All guidance logic runs locally using cached data
*   Watch records to its own local database
*   Sync happens opportunistically when connection restored

**Watch → Cloud Direct Sync (Optional):**
*   Some watches (Apple Watch LTE, Garmin with WiFi) can sync directly to cloud
*   Used as fallback if phone unavailable for extended period
*   Same delta sync protocol as phone ↔ cloud

---

## 3. Implementation Plan

### 3.1. Phasing

**Phase 1: Core Infrastructure (Weeks 1-3)**
*   **Deliverables:**
    *   Monorepo setup (Nx or Turbo)
    *   NestJS backend scaffold with PostgreSQL and Redis
    *   React Native mobile scaffold with WatermelonDB
    *   Basic auth flow (Supabase integration)
*   **Success Criteria:**
    *   User can register and log in on mobile app
    *   Basic API endpoints functional
    *   Database schema deployed

**Phase 2: The Shared Brain (Weeks 4-6)**
*   **Deliverables:**
    *   `@runningcoach/engine` TypeScript package created
    *   Basic plan generation logic (simple rules-based MVP)
    *   Integration with mobile app (logic runs locally)
    *   Unit tests for engine logic
*   **Success Criteria:**
    *   User can generate a basic training plan
    *   Plan displays on mobile app
    *   Logic executes offline

**Phase 3: Sync Infrastructure (Weeks 7-9)**
*   **Deliverables:**
    *   WatermelonDB sync adapter implementation
    *   Delta sync endpoints in backend
    *   Conflict resolution logic
    *   Sync UI indicators
*   **Success Criteria:**
    *   Data syncs between phone and cloud
    *   Offline changes queue and sync when online
    *   No data loss during conflict scenarios

**Phase 4: Mobile MVP (Weeks 10-14)**
*   **Deliverables:**
    *   Core UI screens (Dashboard, Plan Calendar, Workout Detail, Analytics)
    *   Workout logging functionality
    *   Body metrics input
    *   Chart visualizations
*   **Success Criteria:**
    *   User can navigate app and complete core workflows
    *   Offline functionality verified
    *   Visual design matches mockups

**Phase 5: Watch Integration - Apple (Weeks 15-18)**
*   **Deliverables:**
    *   Apple Watch app (SwiftUI)
    *   SQLite database on watch
    *   BLE sync with iPhone (Context Pack, Activity Pack)
    *   Standalone workout mode with basic guidance
*   **Success Criteria:**
    *   User can start workout on watch without phone
    *   Real-time HR guidance works
    *   Workout data syncs back to phone

**Phase 6: Watch Integration - Garmin (Weeks 19-22)**
*   **Deliverables:**
    *   Garmin ConnectIQ app (MonkeyC)
    *   TypeScript-to-MonkeyC transpiler (basic version)
    *   BLE sync with mobile app
    *   Data field integration
*   **Success Criteria:**
    *   Basic workout guidance on Garmin watch
    *   FIT file import to mobile app

**Phase 7: Web Platform (Weeks 23-26)**
*   **Deliverables:**
    *   Next.js web app with IndexedDB
    *   Analytics dashboards
    *   Plan calendar and editing
    *   Account management
*   **Success Criteria:**
    *   Full feature parity with mobile (viewing/editing)
    *   Offline functionality on web

**Phase 8: Polish & Launch Prep (Weeks 27-30)**
*   **Deliverables:**
    *   Performance optimization
    *   Integration testing
    *   Beta user testing
    *   App Store submission
*   **Success Criteria:**
    *   App passes beta testing
    *   Performance benchmarks met
    *   Approved for release

### 3.2. Testing Strategy

**Unit Tests:**
*   **Engine Logic:** Jest tests for all training plan generation, readiness assessment, and load management algorithms
*   **Sync Logic:** Tests for conflict resolution, delta calculation, queue processing
*   **Data Models:** WatermelonDB model tests
*   **Target Coverage:** 80%+ for core logic

**Integration Tests:**
*   **API Tests:** Automated tests for all tRPC endpoints using Vitest
*   **Sync Flow Tests:** End-to-end tests for phone → cloud → phone sync scenarios
*   **Watch Sync Tests:** Simulated BLE transfer tests
*   **Database Migration Tests:** Verify schema changes don't break existing data

**End-to-End Tests:**
*   **User Journey Tests:** Detox (React Native) for critical flows:
    *   User registration → goal setting → plan generation → workout completion
    *   Offline workout → reconnect → sync verification
*   **Web E2E:** Playwright tests for web app

**Offline/Online Transition Tests:**
*   **Network Toggle Tests:** Simulate going offline mid-operation
*   **Data Integrity Tests:** Verify no data loss when network drops during sync
*   **Conflict Scenarios:** Force conflicts and verify resolution logic
*   **Queue Tests:** Verify queued operations execute correctly when reconnected

**Performance Tests:**
*   **Load Tests:** Artillery.io for backend API endpoints (target: 1000 concurrent users)
*   **Stress Tests:** WatermelonDB performance with 10,000+ local records
*   **Latency Benchmarks:** Measure sync latency (target: < 2s for typical payload)
*   **Battery Tests:** Measure watch battery drain during workouts (target: < 5% per hour)

### 3.3. Migration Strategy

**Initial Deployment:**
*   No existing users, so no migration needed for first release
*   Database schema deployed via migrations (Prisma or TypeORM)
*   Seed data for testing environments

**Future Schema Evolution:**
*   **Database Migrations:** Versioned migrations with rollback capability
*   **Mobile Schema Versioning:** WatermelonDB migrations for local schema changes
*   **Logic Bundle Versioning:** Semantic versioning with backward compatibility
*   **Backward Compatibility Window:** Support N-1 version of mobile app for 30 days

**Feature Flags:**
*   Gradual rollout of major features using PostHog feature flags
*   A/B testing for algorithm changes
*   Kill switch for problematic features

**Rollout Plan:**
*   **Alpha:** Internal team (10 users) - week 0
*   **Beta:** Invited runners (100 users) - weeks 1-4
*   **Soft Launch:** Limited App Store availability (select regions) - weeks 5-8
*   **Full Launch:** Global availability - week 9+

### 3.4. Rollback Strategy

**Rollback Triggers:**
*   Critical bug affecting > 10% of users
*   Data integrity issue detected
*   Performance degradation > 50% from baseline
*   Security vulnerability discovered

**Rollback Procedure:**

**Backend:**
1.  Revert to previous Docker image on ECS/Railway (1-click rollback)
2.  Database rollback if migration was deployed:
    *   Run down-migration script
    *   Restore from last backup if needed (target: < 1 hour RPO)
3.  Update logic bundle version in S3 to previous stable version
4.  Monitor error rates return to baseline

**Mobile App:**
1.  Issue EAS Update with previous bundle (over-the-air)
2.  If needed, update required version in backend to force app update
3.  Communicate with users via in-app notification

**Data Integrity:**
*   All destructive operations logged in audit table
*   Point-in-time recovery available for last 7 days
*   User data export capability for manual recovery

**User Impact During Rollback:**
*   Mobile users receive OTA update within minutes
*   Web users refreshed to previous version immediately
*   Data created during failed deployment preserved and merged after fix

---

## 4. Alternatives Considered

| Alternative | Pros | Cons | Reason for Rejection |
|------------|------|------|---------------------|
| **Firebase Backend** | Managed infrastructure, real-time by default, easy auth | Vendor lock-in, limited query flexibility, costly at scale | Need full control over sync logic and data model |
| **Flutter (vs React Native)** | Better performance, single codebase for mobile | Smaller ecosystem, harder to share logic with Web/Backend | JavaScript ecosystem alignment critical for shared Brain |
| **Realm (vs WatermelonDB)** | Built-in sync, MongoDB backend | Proprietary sync, less control over conflict resolution | Need custom delta sync for fine-grained control |
| **GraphQL (vs tRPC)** | Industry standard, flexible queries | More boilerplate, no end-to-end type safety | tRPC provides full TypeScript safety with less code |
| **Native Watch Apps Only** | Best performance | 3x development cost, no code sharing | Shared logic Brain requires JS execution or transpilation |
| **Server-Side Plan Generation** | Easier to update logic | Requires internet, high latency | Offline-first requirement demands local execution |
| **CRDT-based Sync (vs Delta)** | Automatic conflict resolution | Complex, larger data overhead | Delta sync simpler for our conflict patterns |

---

## 5. Cross-Cutting Concerns

### 5.1. Security

**Authentication:**
*   **Provider:** Supabase Auth (JWT-based)
*   **Methods:** Email/password, Google OAuth, Apple Sign-In
*   **Token Strategy:**
    *   Short-lived access tokens (15 min expiry)
    *   Long-lived refresh tokens (30 days, stored securely in device keychain)
    *   Automatic refresh before expiry

**Authorization:**
*   **User-Level:** Users can only access their own data
*   **Role-Based:** Future admin roles for support access (with audit logging)
*   **API Layer:** Middleware validates JWT on every request
*   **Database Layer:** Row-Level Security (RLS) policies in PostgreSQL

**Data Protection:**
*   **At Rest:**
    *   Database: AES-256 encryption (AWS RDS encryption)
    *   Local Device: iOS/Android native encryption (Keychain/Keystore for sensitive data)
    *   S3: Server-side encryption (SSE-S3)
*   **In Transit:**
    *   TLS 1.3 for all HTTPS connections
    *   Certificate pinning for mobile apps
    *   BLE connections encrypted at protocol level

**Privacy:**
*   **PII Handling:** Email, name, birth date stored with access controls
*   **Data Retention:** User can delete account and all data (GDPR "right to erasure")
*   **GDPR Compliance:** Data export feature, explicit consent flows, privacy policy
*   **Analytics:** Privacy-focused (PostHog, no third-party trackers)

**Threat Model:**
*   **Threat:** Unauthorized access to user training data
    *   **Mitigation:** Strong auth, encryption, RLS policies
*   **Threat:** Malicious logic bundle injection
    *   **Mitigation:** Bundle signature verification, TLS for downloads, checksum validation
*   **Threat:** Man-in-the-middle during sync
    *   **Mitigation:** TLS 1.3, certificate pinning
*   **Threat:** Device theft
    *   **Mitigation:** Local DB encryption, JWT short expiry

### 5.2. Performance

**Latency:**
*   **API Response Time:**
    *   Target: p50 < 100ms, p95 < 500ms, p99 < 1s
    *   Optimization: Redis caching for frequently accessed data, indexed queries
*   **Sync Latency:**
    *   Target: < 2s for typical phone ↔ cloud sync (< 100 KB payload)
    *   Optimization: Delta sync (only changes), compression (gzip)
*   **App Launch:**
    *   Target: Cold start < 2s, warm start < 500ms
    *   Optimization: Lazy loading, WatermelonDB query optimization

**Throughput:**
*   **Expected Load:** 10,000 active users, peak 500 concurrent workouts being synced
*   **API Capacity:** 1,000 requests/second (horizontal scaling)
*   **Database Capacity:** PostgreSQL read replicas for analytics queries

**Resource Usage:**
*   **Mobile App:**
    *   **RAM:** < 150 MB active, < 50 MB background
    *   **Storage:** ~100 MB for app + local data
    *   **Battery:** < 5% drain per hour during active use, minimal background drain
*   **Watch App:**
    *   **Battery:** < 5% additional drain per workout hour
    *   **Storage:** < 20 MB (Apple Watch), < 10 MB (Garmin)

**Scalability:**
*   **Horizontal Scaling:**
    *   Backend: Stateless NestJS containers on ECS (auto-scaling based on CPU/memory)
    *   Database: Connection pooling (PgBouncer), read replicas for analytics
    *   Redis: Cluster mode for high availability
*   **Vertical Scaling:**
    *   Start with t3.medium instances, scale to c6i.2xlarge if needed
*   **Load Handling:**
    *   Rate limiting: 100 requests/minute per user
    *   Job queue: BullMQ offloads heavy processing (file parsing, batch jobs)

### 5.3. Observability

**Logging:**
*   **Backend:** Structured logging (JSON) via Winston
    *   **Levels:** error, warn, info, debug
    *   **Events Logged:** API requests, sync operations, job executions, errors
    *   **Retention:** 30 days in CloudWatch or Datadog
*   **Mobile:** Sentry for crash reports and errors
    *   **Breadcrumbs:** User actions leading to error
    *   **Context:** Device info, OS version, app version

**Metrics:**
*   **Backend Metrics (Prometheus + Grafana):**
    *   Request rate, error rate, latency (RED metrics)
    *   Database connection pool usage
    *   Queue depth and job processing time
    *   CPU, memory, disk usage per service
*   **Product Metrics (PostHog):**
    *   User engagement (DAU, WAU, MAU)
    *   Feature usage (plan generation, workout completion)
    *   Sync success/failure rates
    *   Logic bundle update adoption rate

**Tracing:**
*   **Distributed Tracing:** OpenTelemetry for cross-service requests
    *   Trace sync flow: Mobile → API → Database → External Service
    *   Identify bottlenecks in multi-step operations

**Alerting:**
*   **Alert Conditions:**
    *   Error rate > 5% for 5 minutes → PagerDuty alert
    *   API p95 latency > 2s for 10 minutes → Slack alert
    *   Database CPU > 80% for 5 minutes → Email alert
    *   Sync failure rate > 10% → Dashboard flag
*   **On-Call:** Rotating on-call schedule for critical alerts
*   **SLO/SLA:**
    *   **SLO:** 99.5% uptime for API (downtime < 3.6 hours/month)
    *   **SLO:** 99.9% offline availability for mobile app
    *   **No formal SLA** until post-launch

### 5.4. Reliability

**Error Handling:**
*   **Backend:** Try-catch blocks with structured error responses
    *   Differentiate between client errors (4xx) and server errors (5xx)
    *   Return actionable error messages to client
*   **Mobile:** Global error boundary (React), graceful degradation
    *   Show user-friendly error messages
    *   Allow retry for transient failures

**Retries:**
*   **Sync Operations:** Exponential backoff (1s, 2s, 4s, 8s, 16s max)
*   **API Calls:** Automatic retry for 5xx errors (max 3 attempts)
*   **Job Queue:** Failed jobs moved to dead-letter queue for manual review

**Circuit Breakers:**
*   **External Services:** Circuit breaker pattern for Garmin, Strava, weather APIs
    *   Open circuit after 5 consecutive failures
    *   Half-open state after 30s to test recovery
    *   Fallback: Use cached data or skip optional features

**Data Integrity:**
*   **Validation:** Zod schemas for all API inputs and database writes
*   **Checksums:** FIT file uploads verified with SHA-256
*   **Audit Trails:** Log all mutations with user ID, timestamp, and operation
*   **Transactions:** PostgreSQL ACID transactions for multi-table updates

**Disaster Recovery:**
*   **Backup Strategy:**
    *   PostgreSQL automated daily backups (retained 30 days)
    *   S3 versioning enabled for all files
    *   Point-in-time recovery (PITR) window: 7 days
*   **RTO (Recovery Time Objective):** 4 hours from catastrophic failure
*   **RPO (Recovery Point Objective):** < 1 hour (data loss acceptable up to last backup)
*   **Runbook:** Documented procedures for database restore, service recovery

---

## 6. Stakeholder Review

| Stakeholder | Role | Review Status | Sign-off Date |
|------------|------|---------------|---------------|
| System Architect | Technical Design | Approved | 2025-11-26 |
| Backend Lead | Backend Architecture | Pending | - |
| Mobile Lead | Mobile Architecture | Pending | - |
| Product Manager | Roadmap Alignment | Pending | - |
| Security Engineer | Security Review | Pending | - |

---

## 7. Open Questions

*   **Hosting Decision:** Finalize choice between AWS ECS (Fargate) and Railway for backend hosting. Need cost analysis.
*   **Garmin Transpiler Scope:** How much of the TypeScript engine can realistically be transpiled to MonkeyC? May need to limit to basic zone guidance logic.
*   **Watch BLE Performance:** What's the real-world BLE transfer time for a 5 MB FIT file? (typical long run). Need device testing.
*   **Logic Bundle Size Limits:** What's the maximum bundle size watches can handle? Need to test on low-end Garmin devices.
*   **Web Offline Storage Limits:** How much data can we reliably store in IndexedDB across different browsers? Plan for storage quota handling.
*   **GDPR Data Export Format:** What format should user data exports use? JSON, CSV, or both?

---

## 8. References

*   [System Architecture Document](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/architecture/00_SYSTEM_ARCHITECTURE.md) - Foundational architecture decisions
*   [WatermelonDB Documentation](https://watermelondb.dev/docs) - Local database for React Native
*   [ConnectIQ SDK Documentation](https://developer.garmin.com/connect-iq/) - Garmin watch development
*   [WatchOS SDK Documentation](https://developer.apple.com/watchos/) - Apple Watch development
*   [tRPC Documentation](https://trpc.io/) - Type-safe API framework
*   [NestJS Documentation](https://docs.nestjs.com/) - Backend framework
*   [Expo EAS Documentation](https://docs.expo.dev/eas/) - Build and update services
*   [PRD: Overarching Vision](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/00_OVERARCHING_VISION.md) - Product vision
*   [PRD: Sync Infrastructure](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/05_SYNC_INFRASTRUCTURE.md) - Sync requirements
*   [PRD: Adaptive Training Engine](file:///Users/maksat/Projects/RunningCoach/RunningCoach/docs/prd/06_ADAPTIVE_TRAINING_ENGINE.md) - Core logic requirements
