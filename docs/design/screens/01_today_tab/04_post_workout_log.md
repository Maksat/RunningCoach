# Screen: Post-Workout Log (RPE)
**ID:** DASH-04
**Parent Flow:** Dashboard -> Mark Complete

## 1. Purpose
To capture Internal Load (RPE * Duration) which is the primary metric for the Adaptive Engine.

## 2. Layout & Structure
*   **Type:** Card Overlay / Modal.

## 3. UI Components

### 3.1. RPE Selector
*   **Question:** "How hard was that?"
*   **Input:** Circular Dial or Slider (1-10).
*   **Labels:**
    *   1-2: Very Easy (Recovery)
    *   3-4: Easy (Conversation possible)
    *   5-6: Moderate (Breathing deep)
    *   7-8: Hard (Threshold)
    *   9: Very Hard
    *   10: Max Effort
*   **Color Coding:** Blue -> Green -> Orange -> Red.

### 3.2. Duration Confirmation
*   **Input:** "Duration: 1h 05m" (Editable if manual entry).

### 3.3. Notes
*   **Input:** Text Area ("How did you feel?").

### 3.4. Feedback
*   **Display:** "Internal Load: 450" (Calculated live as slider moves).

### 3.5. Actions
*   **Button:** "Save Workout"

## 4. Dynamic Data
*   **Calculation:** `Load = RPE * Duration (minutes)`.

## 5. Design System References
*   **Colors:** RPE scale matches Traffic Light system colors extended (Blue for easy).
