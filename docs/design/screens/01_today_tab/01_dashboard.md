# Screen: Today Dashboard
**ID:** DASH-01
**Parent Flow:** Main Navigation (Tab 1)

## 1. Purpose
The "Cockpit" of the application. Provides immediate situational awareness: Readiness status, Today's Mission (Workout), and Nutrition targets.

## 2. Layout & Structure
*   **Header:**
    *   **Left:** Current Date (e.g., "Mon, Oct 24").
    *   **Right:** Phase Indicator Badge (e.g., "Build Phase - Week 4").
*   **Body:** Vertical Scroll.

## 3. UI Components

### 3.1. Hero: Readiness Indicator
*   **Type:** Large Circular Widget or Dynamic Background Gradient.
*   **Visuals:**
    *   **Green:** Pulsing soft green glow. Text: "Ready to Train".
    *   **Yellow:** Static amber ring. Text: "Caution / Modified".
    *   **Red:** Static red ring. Text: "Rest Required".
*   **Interaction:** Tap opens `DASH-02` (Morning Check-In Modal) if not done, or "Readiness Breakdown" if done.

### 3.2. Primary Card: Today's Workout
*   **Container:** `Glassmorphism` Card.
*   **Content:**
    *   **Icon:** Run / Rest / Cross-Train icon.
    *   **Title:** Workout Name (e.g., "Aerobic Threshold").
    *   **Hero Stat:** Large Typography (e.g., "12 km" or "60 min").
    *   **Sub-stat:** Target Pace/HR (e.g., "@ 5:30/km" or "Zone 2").
    *   **Coach's Note:** "Keep it conversational. Focus on form."
*   **Actions:**
    *   **Primary:** "Start" (if tracking) or "Mark Complete".
    *   **Secondary:** "Pair Watch" (if wearable integration active).
*   **Interaction:** Tap card to view full details (`DASH-03`) or Start Active Workout (`DASH-05`).

### 3.3. Secondary Card: Nutrition
*   **Container:** Smaller Card or Horizontal Strip.
*   **Content:**
    *   **Title:** "Fueling Target"
    *   **Data:** "Carbs: 450g | Protein: 120g"
    *   **Context:** "High Carb Day" (based on workout intensity).
*   **Interaction:** Tap to view Nutrition Detail (`DASH-06`).

## 4. Dynamic Data
*   **Readiness Score:** Calculated from Sleep + HRV + Subjective input.
*   **Workout:** Pulled from `TrainingPlan` for `CurrentDate`.

## 5. Design System References
*   **Colors:** Uses Traffic Light system (Emerald/Amber/Red) for Readiness.
*   **Typography:** Hero Stat uses `JetBrains Mono` or `Inter` (Bold, 48px).
