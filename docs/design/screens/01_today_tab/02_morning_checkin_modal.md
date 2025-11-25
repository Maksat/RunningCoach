# Screen: Morning Check-In
**ID:** DASH-02
**Parent Flow:** Dashboard -> Readiness Interaction

## 1. Purpose
To collect subjective recovery data (Sleep, Mood, Soreness) to calculate the daily Readiness Score.

## 2. Layout & Structure
*   **Type:** Bottom Sheet Modal (Draggable) or Full Screen Overlay.
*   **Navigation:** "Close" (X) top right.

## 3. UI Components

### 3.1. Sliders (The "Vibe Check")
*   **Question 1:** "How did you sleep?"
    *   **Input:** Slider (1-10).
    *   **Visual Feedback:** Slider track changes color (Red -> Yellow -> Green) as value increases.
*   **Question 2:** "How recovered do you feel?"
    *   **Input:** Slider (1-10).
*   **Question 3:** "Any soreness?"
    *   **Input:** Body Map (Tap to select area) OR Simple Slider (None -> Severe).

### 3.2. Resting HR (Optional)
*   **Input:** Number Field.
*   **Auto-fill:** If HealthKit connected, pre-filled with "52 bpm (from Apple Watch)".

### 3.3. Actions
*   **Button:** `Primary Button`
    *   **Label:** "Calculate Readiness"
    *   **Action:** Closes modal -> Updates Dashboard Hero with new Traffic Light status.

## 4. Dynamic Data
*   **Input:** User subjective values.
*   **Output:** Readiness Score (0-100) -> Mapped to Green/Yellow/Red state.

## 5. Design System References
*   **Interaction:** Haptic feedback on slider movement.
*   **Animation:** Background color subtly shifts based on slider average (immersive feedback).
