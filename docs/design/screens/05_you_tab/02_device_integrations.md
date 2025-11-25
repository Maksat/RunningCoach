# Screen: Device Integrations
**ID:** YOU-02
**Parent Flow:** Profile -> Integrations

## 1. Purpose
Manage connections to external services (Garmin, Strava, etc.).

## 2. Layout & Structure
*   **Type:** List of Integration Cards.

## 3. UI Components

### 3.1. Integration List
*   **Card: Garmin Connect**
    *   **Icon:** Garmin Logo.
    *   **Status:** "Connected" (Green Dot) or "Connect" (Button).
    *   **Toggles:**
        *   "Import Activities" (On/Off).
        *   "Push Workouts to Calendar" (On/Off).
*   **Card: Strava**
    *   **Icon:** Strava Logo.
    *   **Status:** "Connect".

### 3.2. Sync Status
*   **Footer:** "Last synced: 2 mins ago."
*   **Action:** "Sync Now" (Manual Trigger).

## 4. Dynamic Data
*   **Status:** Real-time connection status.

## 5. Design System References
*   **Toggles:** Standard platform toggles.
