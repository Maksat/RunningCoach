# Screen: Plan Calendar
**ID:** PLAN-01
**Parent Flow:** Main Navigation (Tab 2)

## 1. Purpose
To visualize the training journey, manage the schedule, and see the "Big Picture" (Phases).

## 2. Layout & Structure
*   **Header:**
    *   **Toggle:** Week | Month.
    *   **Action:** "Life Happens" Button (Floating or Top Right).

## 3. UI Components

### 3.1. Week View (Default)
*   **Type:** Vertical Scroll (Agenda).
*   **Items:** Day Cards (Mon-Sun).
*   **Card Content:**
    *   **Left:** Day Name (e.g., "TUE").
    *   **Center:** Workout Name + Distance.
    *   **Right:** Status Icon (Checkmark, Empty Circle, Skipped).
*   **Interaction:**
    *   **Tap:** Open Workout Details (`DASH-03`).
    *   **Long Press:** Drag and Drop to move to another day.

### 3.2. Month View
*   **Type:** Calendar Grid.
*   **Visuals:**
    *   **Dots:** Colored dots representing workout types (Blue=Run, Orange=Strength).
    *   **Background:** Subtle shading indicating Phases (Base, Build, Peak).
*   **Interaction:** Tap day to expand details.

### 3.3. Phase Indicator
*   **Component:** Sticky Header or Background Watermark.
*   **Text:** "Phase: Build 1 (Week 6/16)".

## 4. Dynamic Data
*   **Schedule:** Fetched from `TrainingPlan`.
*   **Status:** Completed/Missed/Planned.

## 5. Design System References
*   **Colors:**
    *   Past days: Dimmed opacity (0.6).
    *   Future days: Full opacity.
    *   Race Day: Gold/Glowing border.
