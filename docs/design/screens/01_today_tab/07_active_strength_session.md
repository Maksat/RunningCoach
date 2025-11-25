# Screen: Active Strength Session
**ID:** DASH-07
**Parent Flow:** Dashboard -> Start Strength Session

## 1. Purpose
Guides the user through a strength or mobility routine with video guidance, timers, and set tracking.

## 2. Layout & Structure
*   **Type:** Full Screen / Immersive.
*   **Orientation:** Portrait (Video at top).

## 3. UI Components

### 3.1. Video Player (Top 40%)
*   **Content:** Loop of the current exercise (e.g., "Goblet Squat").
*   **Controls:** Mute, Expand.
*   **Overlay:** "Exercise 3 of 8".

### 3.2. Exercise Details (Middle)
*   **Title:** Large Text (e.g., "Goblet Squat").
*   **Target:** "3 Sets x 12 Reps".
*   **Weight:** "Recommended: 16kg" (Editable input for actual weight used).

### 3.3. Action Area (Bottom)
*   **Set Tracker:** Circles representing sets.
    *   Empty: To do.
    *   Filled: Done.
*   **Button:** "Complete Set".
    *   **Interaction:** Triggers Rest Timer.

### 3.4. Rest Timer Overlay
*   **Trigger:** After "Complete Set".
*   **Visual:** Full screen overlay or large modal.
*   **Timer:** Countdown (e.g., "00:59").
*   **Controls:** "+10s", "Skip".
*   **Next Up:** Preview of next exercise.

## 4. Audio Cues
*   **Start:** "Next exercise: Goblet Squat. 3 sets of 12."
*   **Timer:** Beeps at 3, 2, 1.
*   **Completion:** "Great job. Session complete."

## 5. Design System References
*   **Video:** High contrast, professional demonstration.
*   **Timer:** Circular progress ring.
