# Screen: Active Workout
**ID:** DASH-05
**Parent Flow:** Dashboard -> Start Workout

## 1. Purpose
The "In-Flight" screen used during a run. It provides real-time feedback, audio controls, and safety alerts.

## 2. Layout & Structure
*   **Type:** Full Screen / Immersive Mode (Keep Screen On).
*   **Visuals:** High contrast, large typography for readability in motion.

## 3. UI Components

### 3.1. Header
*   **Left:** "05:30 / 10:00 km" (Distance Progress).
*   **Right:** GPS Signal Strength Icon.

### 3.2. Primary Metric (Center)
*   **Metric:** **Pace** (or Power/HR depending on workout type).
*   **Visual:** Massive Typography (e.g., "5:45").
*   **Label:** "min/km".
*   **Color:**
    *   Green: On Target.
    *   Red: Too Fast/Slow.

### 3.3. Secondary Metrics (Grid)
*   **Top Left:** Time Elapsed.
*   **Top Right:** Heart Rate (with Zone Color background).
*   **Bottom Left:** Cadence (spm).
*   **Bottom Right:** Avg Pace.

### 3.4. Interval Guidance (Dynamic)
*   **Component:** Progress Bar at top of metrics.
*   **Text:** "Interval 3/8: 400m @ 4:30".
*   **Countdown:** "150m remaining".

### 3.5. Controls (Bottom)
*   **Center:** Pause / Resume (Large Button).
*   **Hold to Finish:** Prevents accidental stops.
*   **Left:** Lap Button.
*   **Right:** Audio Settings (Voice Feedback Toggle).

## 4. Alerts & Overlays
*   **HR Alert:** Full screen red flash if HR > Max allowed.
*   **Pace Alert:** "Slow Down" / "Speed Up" overlay with haptic vibration.
*   **Audio Cues:** "Interval Complete. Rest for 2 minutes."

## 5. Design System References
*   **Dark Mode:** Always on for battery saving (OLED black).
*   **Typography:** Tabular figures for all changing numbers.
