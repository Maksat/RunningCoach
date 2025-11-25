# PRD: Mobile Client - UX & Interaction Design

## 1. Introduction
This document serves as the comprehensive guide for the UX/UI design of the RunningCoach mobile application. It translates the evidence-based training principles (ACWR, periodization, adaptive logic) into concrete screens, user flows, and interaction models.

**Target Audience:** UX Researchers, UI Designers, Frontend Engineers.
**Goal:** Create a "High-Fidelity" blueprint for Figma prototyping.

## 2. Information Architecture

The application uses a **Bottom Navigation Bar** structure with 5 core tabs:
1.  **Today:** The daily command center. Readiness, workout of the day, immediate actions.
2.  **Plan:** The forward-looking calendar. Schedule management, phase visualization.
3.  **Progress:** Long-term analytics. ACWR, TSB, injury risk monitoring.
4.  **Library:** Educational content. Strength routines, drills, nutrition guides.
5.  **You:** Profile, settings, device management.

## 3. Onboarding & Setup Flow

### 3.1. Welcome & Value Prop
*   **Screen:** Carousel highlighting:
    *   "Evidence-based training, not guesswork."
    *   "Injury prevention first."
    *   "Adapts to your life."
*   **Action:** "Get Started"

### 3.2. Baseline Data Collection
*   **Input Fields:**
    *   Current 5K/10K/HM/Marathon times (or estimates).
    *   Weekly mileage average (last 4 weeks).
    *   Injury history (Checklist: Shin splints, IT band, etc. - informs prehab recommendations).
    *   Goal Race (Date, Distance, Target Time).
    *   Days available to train (M-Su selector).
*   **Logic:** System calculates initial "Chronic Load" baseline.

### 3.3. Device Permissions
*   **HealthKit / Google Fit:** "We need this to import your workouts and sleep data automatically."
*   **Notifications:** "Allow us to nudge you for morning check-ins and post-workout RPE."

---

## 4. Core Navigation Tabs

### 4.1. Tab 1: "Today" (Dashboard)
**Purpose:** The "at a glance" view of what the user needs to do *right now*.

**UI Structure:**
1.  **Header:** Date | Current Phase (e.g., "Base Phase - Week 4").
2.  **Hero Card: Readiness Status (Traffic Light System)**
    *   **Visual:** Large circular indicator or background gradient.
    *   **States:**
        *   🟢 **Green:** "All Systems Go." (Text: "Your recovery is optimal. Stick to the plan.")
        *   🟡 **Yellow:** "Caution." (Text: "Slight fatigue detected. We've reduced today's intensity by 10%." OR "Slight fatigue detected. We've shortened today's workout by 20%.")
        *   🔴 **Red:** "Recovery Needed." (Text: "High risk detected. Today is now a Rest Day.")
    *   **Interaction:** Tap to see breakdown (Sleep score, HRV status, Muscle Soreness).
3.  **Primary Card: Today's Workout**
    *   **Content:**
        *   **Type:** (e.g., "Long Run", "Intervals", "Rest").
        *   **Key Stats:** Distance/Duration, Target Pace/HR Zone.
        *   **Coach's Note:** A human-readable sentence (e.g., "Focus on time on feet today, pace doesn't matter.").
        *   **"Why this workout?":** Expandable accordion explaining the science (e.g., "Long runs build mitochondrial density...").
    *   **Actions:**
        *   "Start Workout" (if using app to track - secondary use case).
        *   "Mark as Complete" (manual log).
        *   "Pair Watch" (if not connected).
4.  **Secondary Card: Nutrition Target**
    *   **Content:** Daily Carb/Protein goal based on *today's* training load.
    *   **Example:** "Moderate Training Day: Aim for 490g Carbs, 105g Protein."
5.  **Fab / Quick Action:** "Log Activity" (for cross-training or manual entry).

### 4.2. Tab 2: "Plan" (Calendar)
**Purpose:** Visualization of the training journey and schedule management.

**UI Structure:**
1.  **View Toggle:** Week | Month.
2.  **Month View:**
    *   **Visual:** Calendar grid.
    *   **Indicators:** Colored dots for workout types (Blue=Run, Orange=Strength, Green=Cross-Training).
    *   **Phase Overlays:** Background shading showing "Base", "Build", "Peak", "Taper" blocks.
3.  **Week View (Default):**
    *   **Vertical List:** Monday - Sunday cards.
    *   **Card Content:** Day, Workout Name, Distance, Status (Completed/Planned/Skipped).
    *   **Drag & Drop:** User can drag a workout from Tuesday to Wednesday.
        *   **Interaction:** On drop, system checks rules (e.g., "Cannot do hard sessions back-to-back").
        *   **Feedback:** If rule violated, show Toast: "Moved, but we swapped Thursday to Easy to preserve recovery."
4.  **"Life Happens" Button (Floating):**
    *   **Menu:** "I'm Sick", "I'm Traveling", "I Missed a Workout".
    *   **Flow (I'm Sick):**
        *   Q: "Symptoms above or below the neck?"
        *   A: "Below (Chest/Body aches)" -> Action: System wipes next 3 days, sets "Return to Run" protocol.
    *   **Flow (Traveling):**
        *   Input: "Dates X to Y".
        *   Action: System redistributes load or switches to Maintenance Mode (min 1 high-intensity + 50% volume).

### 4.3. Tab 3: "Progress" (Analytics)
**Purpose:** Long-term tracking of adaptation and injury risk.

**UI Structure:**
1.  **Chart 1: Injury Risk (ACWR)**
    *   **Visual:** Line chart of Acute:Chronic Ratio.
    *   **Zones:**
        *   Green Band (0.8 - 1.3): "Sweet Spot".
        *   Yellow Band (1.3 - 1.5): "Caution".
        *   Red Zone (> 1.5): "Danger Zone".
    *   **Data Point:** Current value (e.g., 1.1).
2.  **Chart 2: Training Stress Balance (TSB)**
    *   **Visual:** Bar chart (Positive = Freshness, Negative = Fatigue).
    *   **Insight:** "You are in a functional overreaching block. This is good for building fitness."
3.  **Metric: Training Monotony**
    *   **Display:** Score (e.g., 1.4).
    *   **Alert:** If > 2.0, show warning: "Training is too repetitive. Mix up your routes or paces."
4.  **Performance Trends:**
    *   **Running Economy:** Graph of HR vs. Pace over time.
    *   **Lactate Threshold:** Estimated pace evolution.

### 4.4. Tab 4: "Library" (Resources)
**Purpose:** Educational content and auxiliary training tools.

**UI Structure:**
1.  **Categories:** Strength, Drills, Nutrition, Recovery.
2.  **Strength Section:**
    *   **Routines:** "Base Phase Strength", "Core & Hips", "Nordic Curls Progression".
    *   **Content:** Video loops, set/rep counters.
3.  **Drills Section:**
    *   **Videos:** A-Skips, B-Skips, Bounding.
    *   **Guide:** "When to do this" (e.g., "Before speed sessions").
4.  **Nutrition Calculator:**
    *   **Tool:** "Race Week Carb Loader".
    *   **Input:** Weight, Race Date.
    *   **Output:** 3-day meal plan targets (e.g., "Days 3-2 pre-race: 700g carbs/day").
5.  **Cross-Training Equivalency:**
    *   **Tool:** "Run to Bike Converter".
    *   **Input:** "Planned Run: 60 mins Easy".
    *   **Output:** "Bike Equivalent: 90 mins at HR 130bpm".

### 4.5. Tab 5: "You" (Profile)
**Purpose:** Settings and device management.

**UI Structure:**
1.  **User Profile:** HR Max, Zones, Weight.
2.  **Integrations:** Status of Apple Health / Garmin / Strava connections.
3.  **Preferences:**
    *   "Training Days" (Edit availability).
    *   "Notification Settings" (Morning check-in time).
4.  **Subscription:** Status and management.

---

## 5. Key Interaction Flows

### 5.1. Morning Check-In (Daily Ritual)
*   **Trigger:** Push notification (user set time) or opening app.
*   **Screen:** Modal / Full screen overlay.
*   **Question 1:** "How did you sleep?" (Slider 1-10).
*   **Question 2:** "How recovered do you feel?" (Slider 1-10).
*   **Question 3:** "Muscle Soreness?" (Body map tap or Slider 1-10).
*   **Optional:** Resting HR (if not auto-synced).
*   **Result:** System calculates "Readiness Score" -> Updates "Today" tab traffic light.

### 5.2. Post-Workout Logging (The RPE Loop)
*   **Trigger:** 20-30 mins after workout end (detected via HealthKit) or Manual Entry.
*   **Screen:** Card overlay.
*   **Question:** "Rate the effort (RPE) for [Workout Name]"
    *   **Scale:** 0 (Rest) to 10 (Max Effort).
    *   **Visual:** Color coded (Blue=Easy, Green=Moderate, Orange=Hard, Red=Max).
*   **Context:** "Add a note (optional)" (e.g., "Felt sluggish," "Windy").
*   **Feedback:** "Great job! That was a Load of 450 units."

### 5.3. Handling a Missed Workout
*   **Scenario:** User opens app on Wednesday, but Tuesday's run is incomplete.
*   **Prompt:** "It looks like you missed Tuesday's Interval run."
*   **Options:**
    *   "I did it (Manual Log)"
    *   "I missed it (Skip)"
    *   "Reschedule"
*   **Logic (If Skipped):**
    *   If "Long Run" -> System prompts to reschedule to weekend or next available slot.
    *   If "Intervals" -> System checks if Thursday is free. If not, suggests skipping to preserve recovery.
    *   If "Easy Run" -> System marks skipped, no major plan change.

### 5.4. Injury Reporting
*   **Entry:** "Life Happens" -> "I have an injury/pain".
*   **Input:** Location (Knee, Shin, etc.), Pain Level (1-10).
*   **Logic:**
    *   Pain < 3/10: "Monitor closely. We'll switch runs to soft surfaces/easy."
    *   Pain > 3/10: "Switching to Cross-Training Mode."
*   **Outcome:** Plan updates to replace Runs with Aqua Jogging / Cycling sessions for X days.

---

## 6. Offline-First Capabilities

The mobile client must function fully offline to support athletes training in areas without connectivity (see [05_SYNC_INFRASTRUCTURE.md](./05_SYNC_INFRASTRUCTURE.md) for technical implementation details).

### 6.1. Offline Functionality
*   **View Training Plan:** Access next 4-8 weeks of scheduled workouts cached locally
*   **Log Workouts:** Record completed activities with RPE and notes
*   **Complete Morning Check-ins:** Submit readiness data (sleep, recovery, soreness)
*   **Access Library Content:** View cached strength routines, drills, and nutrition guides
*   **Manual Activity Entry:** Log cross-training or workouts from non-connected devices
*   **Seamless Background Sync:** Automatic data synchronization when connectivity restored

### 6.2. Offline User Experience
*   **No Connectivity Required:** Core training workflows function without internet
*   **Sync Indicator:** Small icon showing sync status (synced/pending/syncing)
*   **Optimistic Updates:** Changes appear immediately in UI, sync happens in background
*   **Conflict Resolution:** Backend-generated plan updates take precedence, user notified
*   **Data Consistency:** Local database serves as UI source of truth

### 6.3. Network State Handling
*   **Graceful Degradation:** Features requiring real-time data (weather, race results) show cached data with timestamp
*   **Sync On Launch:** App automatically syncs when opened with connectivity
*   **Manual Refresh:** "Pull to refresh" gesture forces immediate sync
*   **Battery Optimization:** Background sync respects OS constraints (iOS background refresh, Android Doze)

---

## 7. Design System Guidelines

*   **Typography:** Clean, sans-serif (Inter or Roboto). Large, readable numbers for stats.
*   **Color Palette:**
    *   **Primary:** Deep Navy (Professional, Trust).
    *   **Accents:**
        *   Green (Success/Go): #2ECC71
        *   Yellow (Caution/Mod): #F1C40F
        *   Red (Stop/High Intensity): #E74C3C
    *   **Backgrounds:** Off-white/Light Grey (Day mode), Dark Slate (Night mode).
*   **Iconography:** Simple, outlined icons. Filled icons for active states.
*   **Charts:** Minimalist. Avoid 3D effects. Use clear threshold lines.

> [!TIP]
> **Detailed Design System**
> For the comprehensive visual guide, color codes, and component library, please refer to the [UI/UX Design System & Strategy](../design/UI_UX_DESIGN_SYSTEM.md).

