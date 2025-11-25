# Screen: Device Permissions
**ID:** ONB-03
**Parent Flow:** Onboarding

## 1. Purpose
To request necessary system permissions (HealthKit/Google Fit, Notifications) with clear context on *why* they are needed.

## 2. Layout & Structure
*   **Type:** Vertical List of Permission Cards.
*   **Header:** "Let's connect the dots."

## 3. UI Components

### 3.1. Permission Cards
*   **Card 1: Health Data**
    *   **Icon:** Heart/Activity Icon (Red/Pink).
    *   **Title:** "Sync Workouts & Health"
    *   **Description:** "We import your runs, sleep, and heart rate to adapt your training automatically."
    *   **Action:** `Toggle Switch` or `Button` ("Connect").
    *   **System Prompt:** Triggers OS HealthKit/Google Fit permission dialog.
*   **Card 2: Notifications**
    *   **Icon:** Bell Icon (Yellow).
    *   **Title:** "Smart Nudges"
    *   **Description:** "Reminders for morning check-ins and post-run logs. No spam, we promise."
    *   **Action:** `Toggle Switch` or `Button` ("Allow").
    *   **System Prompt:** Triggers OS Notification permission dialog.

### 3.2. Actions
*   **Button:** `Primary Button`
    *   **Label:** "Enter Cockpit" (or "Go to Dashboard")
    *   **Action:** Navigate to `DASH-01` (Today Tab).

## 4. Dynamic Data
*   **State:** Toggles update based on actual OS permission status (e.g., if user denies in OS dialog, toggle turns off).

## 5. Design System References
*   **Cards:** `Glassmorphism` container style.
*   **Icons:** Lucide React / Heroicons (Outline).
