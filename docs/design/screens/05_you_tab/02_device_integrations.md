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
    *   **Interaction:** Tap "Connect" -> Opens OAuth Web View -> Returns to App with Success Toast.

### 3.2. Pairing Flow (Modal)
*   **Trigger:** Tap "Connect" on any integration.
*   **Steps:**
    1.  **Explanation:** "We need access to your Activities and Health Metrics to customize your plan."
    2.  **OAuth Login:** External browser/webview.
    3.  **Permissions:** User approves scopes.
    4.  **Success:** "Garmin Connected! Syncing last 30 days of history..." (Progress Bar).

### 3.3. Sync Status
*   **Footer:** "Last synced: 2 mins ago."
*   **Action:** "Sync Now" (Manual Trigger).

## 4. Dynamic Data
*   **Status:** Real-time connection status.

## 5. Design System References
*   **Toggles:** Standard platform toggles.
