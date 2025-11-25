# Screen: Profile & Settings
**ID:** YOU-01
**Parent Flow:** Main Navigation (Tab 5)

## 1. Purpose
Manage user profile, preferences, and account settings.

## 2. Layout & Structure
*   **Type:** List View (Settings style).

## 3. UI Components

### 3.1. User Header
*   **Avatar:** User photo or Initials.
*   **Name:** "Maksat K."

### 3.2. Settings Groups
*   **Group: Physiology**
    *   "Max HR" (Editable).
    *   "Weight" (Editable).
    *   "Zones" (View Only).
*   **Group: Preferences**
    *   "Training Days" (M-Su Toggles).
    *   "Notifications".
*   **Group: System**
    *   "Integrations" (Link to `YOU-02`).
    *   "Subscription".
    *   "Log Out".

## 4. Dynamic Data
*   **User Data:** Fetched from `UserProfile`.

## 5. Design System References
*   **Lists:** Standard iOS/Android settings list styling.
