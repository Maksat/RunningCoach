# RFC 0002: Mobile Application Architecture

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0002 |
| **Author(s)** | Mobile Lead |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
The mobile application is the primary interface for the user and the local host for the "Brain" (Adaptive Training Engine). It must be performant, offline-first, and visually premium.

### 1.2. Goals
*   **Offline-First:** All features work without network.
*   **Reactive UI:** Changes in DB reflect immediately in UI.
*   **Shared Logic:** Execute the `@runningcoach/engine` locally.
*   **Premium UX:** Smooth animations, haptics, "Glassmorphism" design.

## 2. Proposed Solution

### 2.1. Architecture Overview
We will use a **Layered Architecture**:

1.  **UI Layer:** React Native components, Screens, Navigation.
2.  **State/ViewModel Layer:** Zustand stores, WatermelonDB Observables.
3.  **Domain Layer:** `@runningcoach/engine` (The Brain).
4.  **Data Layer:** WatermelonDB (Local DB), SyncAdapter.
5.  **Infrastructure Layer:** Bluetooth, Sensors, Notifications.

### 2.2. Directory Structure
```
src/
  app/              # Navigation & Entry points
  components/       # Reusable UI components (Atoms, Molecules)
  features/         # Feature-based modules (Dashboard, Plan, etc.)
    dashboard/
      components/
      screens/
      hooks/
  database/         # WatermelonDB schema, models, migrations
  services/         # API, Sync, Bluetooth, Sensors
  store/            # Global UI state (Zustand)
  theme/            # Design system tokens (Colors, Typography)
  utils/            # Helpers
```

### 2.3. Data Layer: WatermelonDB
We choose WatermelonDB for its performance with large datasets and built-in sync capabilities.

#### 2.3.1. Schema
*   `users`: Profile data.
*   `activities`: Workouts (synced from wearables or manual).
*   `daily_metrics`: Sleep, HRV, Soreness.
*   `training_plan`: Generated workouts.
*   `sync_queue`: Pending changes to push.

#### 2.3.2. Sync Strategy
*   **Pull:** Download changes since `last_pulled_at`.
*   **Push:** Upload created/updated/deleted records.
*   **Conflict:** Server wins for computed data, Client wins for subjective data.

### 2.4. The "Brain" Integration
The `@runningcoach/engine` package will be installed as a dependency.

```typescript
// Example usage in a background task or hook
import { analyzeBodyState } from '@runningcoach/engine';

const runAnalysis = async () => {
  const metrics = await database.get('daily_metrics').query(...).fetch();
  const plan = await database.get('training_plan').query(...).fetch();
  
  const result = analyzeBodyState(metrics, plan);
  
  // Update DB with result
  await database.write(async () => {
    await result.saveTo(database);
  });
};
```

### 2.5. UI/UX Implementation
*   **Styling:** `StyleSheet.create` or a lightweight utility library (e.g., `tamagui` or custom theme hooks) to match the "Glassmorphism" design.
*   **Animations:** `react-native-reanimated` for high-performance interactions.
*   **Charts:** `victory-native` for data viz.

## 3. Implementation Plan

### 3.1. Phase 1: Foundation
*   Setup Expo project.
*   Configure WatermelonDB.
*   Implement Auth flow.

### 3.2. Phase 2: Core Features
*   Dashboard Screen (Readiness display).
*   Plan Screen (Calendar view).
*   Manual Activity Logging.

### 3.3. Phase 3: Sync & Logic
*   Connect SyncAdapter.
*   Integrate `@runningcoach/engine`.

## 4. Open Questions
*   **Background Execution:** How do we run the "Brain" reliably in the background on iOS? (Likely need `react-native-background-fetch` or process on app open).
