# RFC 0007: Load Management Service

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0007 |
| **Author(s)** | Sports Science Lead |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
Injury prevention is a core pillar of RunningCoach. The primary mechanism for this is monitoring the **Acute-to-Chronic Workload Ratio (ACWR)**.

### 1.2. Goals
*   **Accuracy:** Calculate load based on RPE * Duration (Internal Load).
*   **Timeliness:** Update risk scores immediately after workouts.
*   **Actionability:** Trigger interventions when risk is high.

## 2. Proposed Solution

### 2.1. Metric Definitions
*   **Load Unit:** `RPE (0-10) * Duration (minutes)`.
*   **Acute Load:** Exponentially Weighted Moving Average (EWMA) of last 7 days.
*   **Chronic Load:** EWMA of last 28 days.
*   **ACWR:** `Acute Load / Chronic Load`.

### 2.2. Calculation Logic (The Algorithm)
Implemented in `@runningcoach/engine`.

```typescript
function calculateLoad(activities: Activity[]): DailyLoad[] {
  // 1. Sum load per day
  // 2. Calculate EWMA for Acute (7d)
  // 3. Calculate EWMA for Chronic (28d)
  // 4. Derive ACWR
}
```

### 2.3. Risk Zones & Interventions

| ACWR Range | Zone | Risk | Intervention |
| :--- | :--- | :--- | :--- |
| **0.8 - 1.3** | **Green** | Optimal | None. |
| **1.3 - 1.5** | **Yellow** | Moderate | Reduce volume by 10-20%. |
| **> 1.5** | **Red** | High | Mandatory Recovery Week (50% volume). |
| **< 0.8** | **Blue** | Detraining | Increase load gradually. |

### 2.4. Data Collection
*   **RPE Prompt:** Critical. If RPE is missing, we cannot calculate Internal Load accurately.
*   **Fallback:** If RPE missing, estimate based on HR Zone or Pace (External Load), but flag as "Estimated".

### 2.5. User Notification
*   **Post-Workout:** "Load: 450 units. ACWR: 1.1 (Safe)."
*   **Warning:** "ACWR is 1.4. We've reduced your long run distance."

## 3. Implementation Plan

### 3.1. Phase 1: Logic
*   Implement `calculateLoad` in `@runningcoach/engine`.
*   Unit tests with standard training scenarios.

### 3.2. Phase 2: UI Integration
*   Display ACWR Gauge on Dashboard.
*   Implement "Missing RPE" prompt.

## 4. Open Questions
*   **Cross-Training:** How to weight Cycling/Swimming?
    *   *Decision:* Use RPE * Duration directly. 60min hard swim (RPE 8) = 480 units. This captures *internal* stress, even if impact is lower. We track "Skeletal Load" (Impact) separately via mileage/steps.
