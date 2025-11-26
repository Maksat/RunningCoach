# RFC 0001: System Architecture & Technology Stack

| Status        | Accepted |
| :---          | :--- |
| **RFC #**     | 0001 |
| **Author(s)** | System Architect |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
This RFC defines the high-level technical architecture for the RunningCoach application. It translates the vision outlined in `docs/prd/00_OVERARCHING_VISION.md` and `docs/architecture/00_SYSTEM_ARCHITECTURE.md` into concrete technical decisions.

### 1.2. Problem Statement
We need a distributed, offline-first system that can provide complex, adaptive training guidance across multiple devices (Phone, Watch, Web) with intermittent connectivity. The "Brain" of the system must be portable and updatable without full app releases.

### 1.3. Goals
*   **Offline-First:** Full functionality without internet.
*   **Distributed Logic:** The "Brain" runs on the edge (Phone/Watch).
*   **Platform Agnostic:** Support iOS, Android, Garmin, Apple Watch.
*   **Scalable:** Backend handles heavy lifting and data aggregation.

## 2. Proposed Solution

### 2.1. High-Level Topology

The system consists of three main nodes:
1.  **Cloud Backend:** The "Archive" & Heavy Lift.
2.  **Mobile App:** The "Primary Brain" & UI.
3.  **Watch App:** The "Field Companion" & Data Collector.

```mermaid
graph TD
    subgraph Cloud ["Cloud Backend"]
        API[API Gateway (NestJS)]
        DB[(PostgreSQL)]
        Redis[Redis Cache/Queue]
        S3[S3 Storage]
    end

    subgraph Phone ["Mobile App (React Native)"]
        WatermelonDB[(WatermelonDB)]
        LogicEngine[Shared Logic Engine (JS)]
        SyncManager[Sync Manager]
    end

    subgraph Watch ["Watch App (Native/ConnectIQ)"]
        LocalDB[(Local DB)]
        LogicLite[Logic Engine Lite]
    end

    Phone <-->|HTTPS / Delta Sync| Cloud
    Watch <-->|BLE| Phone
```

### 2.2. Technology Stack

#### 2.2.1. Mobile App (iOS & Android)
*   **Framework:** React Native (Expo)
*   **Language:** TypeScript
*   **Local DB:** WatermelonDB (SQLite based, observable)
*   **State Management:** Zustand
*   **Logic Runtime:** Hermes Engine (executing shared JS bundle)

#### 2.2.2. Backend Services
*   **Runtime:** Node.js 20 LTS
*   **Framework:** NestJS
*   **Database:** PostgreSQL 16
*   **Queue:** BullMQ (Redis)
*   **API:** tRPC (for type safety) + REST (for webhooks)
*   **Auth:** Supabase Auth

#### 2.2.3. Watch Apps
*   **Apple Watch:** SwiftUI + CoreData/SQLite
*   **Garmin:** MonkeyC (ConnectIQ SDK)

#### 2.2.4. Web Platform
*   **Framework:** Next.js 14 (App Router)
*   **Hosting:** Vercel / AWS

### 2.3. The "Shared Brain" Concept
To ensure consistency across platforms, the core adaptive logic (training plan generation, readiness assessment) is encapsulated in a **portable TypeScript package** (`@runningcoach/engine`).

*   **Deployment:** Published as an NPM package.
*   **Mobile:** Bundled with the app, updated via OTA (CodePush or custom logic fetch).
*   **Backend:** Imported directly.
*   **Watch:** Transpiled to MonkeyC (Garmin) or run in JSC (Apple Watch).

## 3. Implementation Plan

### 3.1. Phasing
1.  **Phase 1: Core Infrastructure:** Setup Monorepo (Nx/Turbo), Backend NestJS scaffold, Mobile React Native scaffold.
2.  **Phase 2: The Engine:** Implement `@runningcoach/engine` with basic logic.
3.  **Phase 3: Sync Layer:** Implement WatermelonDB <-> Backend sync.
4.  **Phase 4: Mobile MVP:** Basic UI + Engine integration.
5.  **Phase 5: Wearable Integration:** Garmin/HealthKit data ingestion.

## 4. Cross-Cutting Concerns

### 4.1. Security
*   **Data at Rest:** Encrypted (AES-256) on device and server.
*   **Data in Transit:** TLS 1.3.
*   **Auth:** JWT based, short-lived access tokens, secure refresh tokens.

### 4.2. Scalability
*   **Stateless Backend:** Horizontal scaling via Docker/K8s.
*   **Database:** Read replicas for heavy read loads (analytics).
*   **Job Queue:** Offload heavy processing (file parsing, notifications) to background workers.
