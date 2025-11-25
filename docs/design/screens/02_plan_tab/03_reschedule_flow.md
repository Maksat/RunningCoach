# Screen: Reschedule Flow
**ID:** PLAN-03
**Parent Flow:** Plan Tab -> Drag & Drop OR Life Happens

## 1. Purpose
To handle moving workouts while respecting physiological constraints (e.g., no back-to-back hard days).

## 2. Layout & Structure
*   **Type:** Toast Notification / Confirmation Dialog.

## 3. UI Components

### 3.1. Conflict Resolution
*   **Scenario:** User moves "Intervals" to the day after "Long Run".
*   **Alert:** "Careful! That's two hard days in a row."
*   **Options:**
    *   "Move anyway" (Override).
    *   "Let Coach fix it" (Engine swaps surrounding easy days).
    *   "Cancel".

### 3.2. Success State
*   **Toast:** "Plan updated. We moved Thursday's easy run to Friday to balance the load."

## 4. Dynamic Data
*   **Logic:** Engine checks `HardDay` adjacency rules.

## 5. Design System References
*   **Alerts:** `Warning` color (Amber) for conflicts.
