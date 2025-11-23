# PRD: Internal Sync Infrastructure

## 1. Introduction
This document defines the architecture for data synchronization between the Mobile Client (Thin Client) and the Backend "Brain". The sync infrastructure enables offline-first functionality while maintaining data consistency across devices and ensuring the backend remains the authoritative source for complex calculations and training plans.

**Scope:** This PRD covers internal client-backend synchronization only. External integrations (wearables, weather APIs, race databases, etc.) are covered in [13_EXTERNAL_INTEGRATIONS.md](./13_EXTERNAL_INTEGRATIONS.md).

## 2. Core Principles
*   **Offline First:** The mobile application must be fully functional without an internet connection. The local database is the single source of truth for the UI.
*   **Backend Authority:** The backend is the ultimate source of truth for complex calculations, training plans, and long-term data storage.
*   **Seamless Experience:** Sync happens automatically in the background without requiring manual user intervention.
*   **Conflict-Resistant:** Design data model and sync protocol to minimize conflicts; resolve intelligently when they occur.

## 3. Offline-First Data Model

### 3.1. Local Storage (Mobile Client)
*   **Technology:** SQLite (Android/iOS), Realm, or WatermelonDB
*   **Stored Data:**
    *   Current training plan (next 4-8 weeks of scheduled workouts)
    *   Recent activity logs (last 90 days)
    *   Daily metrics (readiness, sleep, soreness for last 90 days)
    *   User profile and settings
    *   Pending changes queue (actions waiting to sync)
    *   Cached static content (exercise library videos, nutritional guidance, coach notes templates)

### 3.2. Read/Write Operations
*   **All UI interactions** read from and write to the local database immediately
*   **No network dependency** for core functionality: viewing plan, logging workouts, recording daily check-ins
*   **Optimistic UI updates:** Changes appear instantly in UI, sync happens asynchronously in background

### 3.3. Data Partitioning
*   **User-specific data:** Partitioned by `user_id`, isolated per user
*   **Shared reference data:** Exercise definitions, training zones formulas, scientific content (read-only, periodically refreshed)
*   **Sync markers:** Each synced entity has `last_modified_at` timestamp and `sync_status` (pending/synced/conflict)

## 4. Synchronization Protocol

### 4.1. Delta Sync (Bidirectional)
To minimize data usage and battery drain, only changed data is transmitted.

**Upstream (Client → Backend):**
*   Completed workouts with RPE and notes
*   Manual activity logs
*   Daily check-in data (recovery rating, sleep, soreness)
*   Plan adjustments (user-initiated reschedules)
*   Settings changes

**Downstream (Backend → Client):**
*   New/adapted training plan updates
*   Processed activity insights (ACWR, TSB calculations)
*   External data updates (wearable data normalized by backend)
*   Coach's Notes for upcoming workouts
*   Alerts and notifications (injury risk warnings, recovery week triggers)

### 4.2. Synchronization Triggers

**Immediate Sync (High Priority):**
*   User completes a workout and logs RPE
*   User submits morning check-in
*   User modifies critical settings (goal race date, available training days)
*   Occurs when network available, retries with exponential backoff if fails

**Background Sync (Periodic):**
*   Every 15-60 minutes when app is in background
*   Subject to OS constraints (iOS background refresh, Android Doze mode)
*   Pulls down new plan adaptations and backend-calculated metrics

**On-Launch Sync:**
*   Triggered when app is opened from closed state
*   Ensures user sees most up-to-date plan and recommendations

**Manual Sync:**
*   User-initiated "Refresh" button in app
*   Forces immediate bidirectional sync

### 4.3. Sync Session Flow

```
1. Client initiates sync request
   POST /sync/check
   Body: { user_id, last_sync_timestamp, pending_changes_count }

2. Backend responds with sync manifest
   Response: {
     has_updates: true/false,
     server_changes_available: ["plan_v23", "acwr_updated", "alerts_new"],
     accepts_client_changes: true/false,
     server_timestamp: "2025-01-15T14:23:00Z"
   }

3. Client uploads pending changes
   POST /sync/upload
   Body: {
     activities: [...],
     daily_metrics: [...],
     settings_changes: [...]
   }

4. Backend processes and responds
   Response: {
     accepted: [...],
     conflicts: [...],
     processing_errors: [...]
   }

5. Client downloads server updates
   GET /sync/download?since=2025-01-14T08:00:00Z
   Response: {
     training_plan: {...},
     calculated_metrics: {...},
     alerts: [...]
   }

6. Client applies updates locally
   - Merge non-conflicting data
   - Resolve conflicts per conflict resolution strategy
   - Update last_sync_timestamp

7. Client marks sync complete
   POST /sync/complete
   Body: { sync_id, status: "success" }
```

## 5. Conflict Resolution

### 5.1. Conflict-Resistant Design
Minimize conflicts through data model design:
*   **Append-only logs:** Activities and daily metrics are append-only (never edited after creation)
*   **Server-generates plans:** Client never modifies training plan structure, only requests adaptations
*   **User owns subjective data:** RPE, notes, feelings are client-authoritative
*   **Backend owns computed data:** ACWR, TSB, recommendations are backend-authoritative

### 5.2. Conflict Resolution Strategy

**Strategy:** "Smart Merge" with Backend Authority for computed values, Client Authority for subjective values.

**Scenario 1: Same Activity, Different Data**
*   User edits workout on phone (adds notes) while backend processes GPS data from Garmin.
*   **Resolution:**
    *   Backend GPS data (distance, pace, HR) wins for objective metrics
    *   Client notes, RPE, feeling win for subjective metrics
    *   Merge both into final record

**Scenario 2: Plan Modification Collision**
*   User reschedules workout while offline.
*   Backend generates new adaptive plan during same period.
*   **Resolution:**
    *   Backend's new plan wins (overwrites local schedule)
    *   User's reschedule request is logged as "superseded by adaptive plan"
    *   Display notification: "Your training plan was updated based on your recent workouts. The manual reschedule has been replaced."

**Scenario 3: Duplicate Activity**
*   Same workout imported from Garmin AND manually logged.
*   **Resolution:**
    *   Match by timestamp (within 10-minute window) + activity type
    *   Wearable data takes precedence for objective metrics
    *   Manual log preserved if it contains additional subjective data (notes, RPE if wearable lacks it)
    *   Merge into single activity record

**Scenario 4: Settings Conflict**
*   User changes goal race date on phone and tablet simultaneously.
*   **Resolution:**
    *   Last-write-wins based on server timestamp
    *   Both clients sync and adopt the latest value
    *   Edge case: If timestamps identical (rare), client with higher `device_id` lexicographically wins

### 5.3. Conflict Notification
*   Display in-app notification when conflicts are resolved
*   User can review conflict log: "Your manual activity log was merged with Garmin data"
*   Provide "Undo" option for 24 hours if user disagrees with resolution

## 6. Data Consistency & Integrity

### 6.1. Transactional Sync
*   Upload and download operations are atomic within their respective scopes
*   If partial upload fails, entire batch is retried (idempotency via unique request IDs)
*   Downloaded data applied in single local transaction (all-or-nothing)

### 6.2. Idempotency
*   All sync requests include unique `sync_request_id`
*   Backend tracks processed requests (TTL 7 days)
*   Duplicate requests return cached response without re-processing

### 6.3. Eventual Consistency
*   System is eventually consistent, not immediately consistent
*   Acceptable delay: up to 15 minutes for non-critical updates
*   Critical updates (injury alerts, illness protocols) trigger push notifications

### 6.4. Data Validation
*   Client validates data before upload (schema compliance, reasonable value ranges)
*   Backend re-validates all uploaded data
*   Invalid data rejected with clear error messages

## 7. Bandwidth & Performance Optimization

### 7.1. Compression
*   Use gzip compression for all sync payloads (typically 70-85% reduction)
*   Large GPS tracks use binary format (FIT file or compressed JSON)

### 7.2. Incremental Updates
*   Training plans sent as diffs, not full plans
*   Example: "Update workout on 2025-01-20 from Tempo to Easy"
*   Reduces typical plan update from 50KB to <1KB

### 7.3. Prioritization
*   High priority: User-generated content (workouts, check-ins)
*   Medium priority: Backend recommendations, alerts
*   Low priority: Static content updates (exercise videos, articles)

### 7.4. Network Detection
*   Detect connection type (WiFi, cellular, offline)
*   On cellular: sync only high-priority data, defer large downloads
*   On WiFi: full sync including media assets
*   Offline: queue all changes, sync when connection restored

## 8. Security

### 8.1. Authentication
*   All sync requests authenticated via JWT (access token)
*   Tokens expire after 24 hours, refreshed automatically
*   Device-specific tokens allow revocation (logout on one device)

### 8.2. Encryption
*   **In Transit:** TLS 1.3 for all API communication
*   **At Rest (Device):** OS-level encryption (iOS Keychain, Android EncryptedSharedPreferences)
*   **At Rest (Server):** Database encryption for sensitive data (HR, sleep, location)

### 8.3. Access Control
*   User data strictly partitioned by `user_id`
*   API endpoints enforce user context from auth token
*   No cross-user data leakage possible

## 9. Offline Scenarios & Edge Cases

### 9.1. Extended Offline Period (Days)
*   Training plan cached for 4-8 weeks (sufficient for most marathon training phases)
*   User can view and complete workouts offline
*   Daily check-ins stored locally, queued for upload
*   On reconnect: Bulk upload queued data, download latest plan adaptations

### 9.2. Device Switching
*   User switches from phone to tablet mid-day
*   Last-synced data is available on new device
*   In-progress workout not synced (prompt to complete on original device or re-log)

### 9.3. App Reinstall / Device Reset
*   User reinstalls app or gets new device
*   On login: Full sync downloads last 90 days of data
*   Cached media re-downloaded on-demand (lazy loading)

### 9.4. Backend Downtime
*   Client continues functioning offline
*   Queued changes persist in local database
*   When backend returns: Automatic retry with exponential backoff
*   User sees status banner: "Syncing paused - will retry automatically"

## 10. Technical Architecture

### 10.1. Client Components
*   **Sync Manager:** Orchestrates sync lifecycle
*   **Local Database:** SQLite/Realm with migration support
*   **Pending Queue:** FIFO queue of changes awaiting upload
*   **Network Monitor:** Detects connectivity changes
*   **Conflict Resolver:** Applies merge strategies locally

### 10.2. Backend Components
*   **Sync Service:** Handles `/sync/*` endpoints
*   **Change Log:** Tracks server-side data changes per user
*   **Conflict Detector:** Identifies overlapping modifications
*   **Idempotency Cache:** Redis cache of processed sync requests (7-day TTL)

### 10.3. API Endpoints
*   `POST /sync/check` - Check for updates
*   `POST /sync/upload` - Upload client changes
*   `GET /sync/download` - Download server changes
*   `POST /sync/complete` - Mark sync session complete
*   `GET /sync/status` - Get current sync state for debugging

### 10.4. Data Flow Diagram
```
[Mobile Client Local DB]
    ↕ (bidirectional sync)
[Sync Manager]
    ↕ (HTTPS/TLS)
[Backend Sync Service]
    ↕
[Main Database]
    ← (processed data from)
[Adaptive Training Engine]
```

## 11. Monitoring & Observability

### 11.1. Metrics
*   **Sync Success Rate:** % of successful sync sessions (target >99%)
*   **Sync Latency:** Time from trigger to completion (target <5 seconds for typical session)
*   **Conflict Rate:** % of syncs with conflicts (target <0.1%)
*   **Retry Rate:** % of syncs requiring retries (indicates network issues or backend problems)

### 11.2. Logging
*   Client logs sync events with anonymized IDs
*   Backend logs full sync session details (request ID, user ID, changes processed)
*   Retain logs 30 days for debugging

### 11.3. User-Facing Indicators
*   Sync status icon: Green (synced), Yellow (syncing), Red (failed—will retry)
*   Last synced timestamp: "Synced 2 minutes ago"
*   Pending changes badge: "3 activities waiting to sync"

## 12. Testing Strategy

### 12.1. Unit Tests
*   Sync Manager state transitions
*   Conflict resolution logic
*   Data validation rules

### 12.2. Integration Tests
*   Full sync cycle (upload → download → apply)
*   Offline queue persistence
*   Conflict scenarios (simulated)

### 12.3. End-to-End Tests
*   Real device testing with airplane mode toggling
*   Multi-device sync (same user, two devices)
*   Backend downtime simulation

## 13. Success Metrics
*   **Offline Usability:** 100% of core features work without network
*   **Sync Reliability:** >99% success rate
*   **Data Consistency:** Zero data loss incidents
*   **User Satisfaction:** <1% of users report sync-related issues
*   **Performance:** 95th percentile sync latency <10 seconds

## 14. Related PRDs
*   [00_OVERARCHING_VISION.md](./00_OVERARCHING_VISION.md) - Offline-first architectural principle
*   [01_MOBILE_CLIENT.md](./01_MOBILE_CLIENT.md) - Client-side sync UI
*   [02_BACKEND_CORE.md](./02_BACKEND_CORE.md) - Sync service implementation
*   [03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md) - Wearable data sync after import
*   [13_EXTERNAL_INTEGRATIONS.md](./13_EXTERNAL_INTEGRATIONS.md) - External API integrations
