# RFC 0005: Adaptive Training Engine (The Brain)

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0005 |
| **Author(s)** | Lead Algorithm Engineer |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
The core value proposition of RunningCoach is "Intelligent Adaptability." The system must analyze physiological data and adjust training plans daily. This logic needs to run on the server (for heavy analysis) and the client (for offline updates).

### 1.2. Goals
*   **Portability:** Logic runs on Node.js, React Native (Hermes), and potentially WatchOS.
*   **Determinism:** Same inputs = Same outputs, regardless of platform.
*   **Updatability:** Update logic without full app store releases.

## 2. Proposed Solution

### 2.1. Architecture: The Logic Bundle
We will create a standalone TypeScript package: `@runningcoach/engine`.

*   **No Dependencies:** Pure logic. No DB access, no API calls.
*   **Inputs:** `UserProfile`, `History` (Activities, Metrics), `CurrentPlan`.
*   **Outputs:** `BodyState` (Readiness), `PlanAdaptation` (Modified Workouts).

### 2.2. The 4-System Analysis Model
The engine implements the logic defined in `docs/prd/06_ADAPTIVE_TRAINING_ENGINE.md`.

```typescript
interface BodyState {
  cardio: SystemStatus;   // HRV, RHR
  muscular: SystemStatus; // Soreness, Volume
  skeletal: SystemStatus; // ACWR
  cns: SystemStatus;      // Sleep, Stress
  overall: ReadinessScore;
}

type SystemStatus = 'Green' | 'Yellow' | 'Red';
```

#### 2.2.1. Logic Flow
1.  **Normalize Inputs:** Convert raw metrics (ms, bpm) to Z-scores based on 30-day baseline.
2.  **Evaluate Systems:**
    *   `Cardio`: Check HRV vs Baseline.
    *   `Skeletal`: Calculate ACWR (Acute:Chronic Workload Ratio).
    *   `Muscular`: Check subjective soreness & volume spike.
    *   `CNS`: Check sleep quality & stress.
3.  **Synthesize:** Apply the "Synthesis Matrix" (e.g., if Skeletal is Yellow -> Remove impact).
4.  **Adapt Plan:**
    *   Fetch today's scheduled workout.
    *   Apply modifiers (e.g., `intensity * 0.8`, `duration * 0.5`, or `swap(Run, Cycle)`).

### 2.3. Dynamic Updates (OTA)
To allow rapid iteration of coaching logic:
1.  **Build:** CI pipeline builds `@runningcoach/engine` into a single JS bundle (`logic.bundle.js`).
2.  **Distribute:** Upload to S3/CDN with versioning.
3.  **Fetch:** Mobile app checks for new bundle on launch.
4.  **Load:** React Native loads the bundle into a separate JS context (or uses `eval` if safe/sandboxed, or simply replaces the module if using CodePush).
    *   *Recommendation:* Use **CodePush** (Microsoft App Center) for the whole React Native bundle updates, or a custom "Rule Engine" (JSON-based rules) if full code push is too heavy. Given the complexity, CodePush is preferred for the MVP.

## 3. Implementation Plan

### 3.1. Phase 1: The Package
*   Scaffold `@runningcoach/engine`.
*   Implement `calculateACWR`, `analyzeHRV`.
*   Unit tests with real user data scenarios.

### 3.2. Phase 2: Integration
*   Integrate into NestJS backend (for nightly batch processing).
*   Integrate into React Native (for offline "Morning Check-in" processing).

## 4. Open Questions
*   **WatchOS:** Running full JS engine on Apple Watch is possible (JSC) but heavy.
    *   *Decision:* Watch runs a "Lite" version or just receives the *result* of the phone's analysis. For MVP, Watch is a display/recorder, Phone is the Brain.
