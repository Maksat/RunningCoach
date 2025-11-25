# Screen: Baseline Data Collection
**ID:** ONB-02
**Parent Flow:** Onboarding

## 1. Purpose
To collect the minimum viable data points required to calculate the user's initial "Chronic Load" and generate a starting plan.

## 2. Layout & Structure
*   **Type:** Multi-step Form (Wizard) or Long Scroll.
*   **Progress:** Progress bar at top indicating steps (e.g., "Step 1 of 3").

## 3. UI Components

### 3.1. Section: Running History
*   **Input:** `Number Input` (with unit selector km/miles)
    *   **Label:** "Average Weekly Distance (Last 4 weeks)"
    *   **Helper Text:** "Be honest! This sets your safety baseline."
*   **Input:** `Time Picker` / `Duration Input`
    *   **Label:** "Recent Race Time (Optional)"
    *   **Type:** 5K, 10K, Half, Full.

### 3.2. Section: Goal
*   **Input:** `Date Picker`
    *   **Label:** "Target Race Date"
*   **Input:** `Dropdown` / `Card Selection`
    *   **Label:** "Race Distance"
    *   **Options:** Marathon, Half Marathon, 10K, 5K.
*   **Input:** `Time Picker`
    *   **Label:** "Goal Time (Optional)"

### 3.3. Section: Availability
*   **Input:** `Day Selector` (7 circular toggles M T W T F S S)
    *   **Label:** "Which days can you train?"
    *   **Interaction:** Tap to toggle. Active = Electric Blue.

### 3.4. Section: Injury History
*   **Input:** `Multi-select Chips`
    *   **Label:** "Do you have a history of..."
    *   **Options:** Shin Splints, IT Band, Runner's Knee, Achilles, None.
    *   **Logic:** Selection triggers specific prehab recommendations in the plan.

### 3.5. Actions
*   **Button:** `Primary Button`
    *   **Label:** "Build My Plan"
    *   **State:** Disabled until required fields (Weekly Distance, Race Date) are filled.
    *   **Action:** Submit data -> System calculates Chronic Load -> Navigate to `ONB-03`.

## 4. Dynamic Data
*   **Validation:** Ensure Race Date is at least 8-12 weeks out (warning if too soon).

## 5. Design System References
*   **Forms:** Inputs use `Surface Light` background with `Secondary Text` placeholders. Focus state: `Electric Blue` border.
*   **Typography:** H2 for Section Headers.
