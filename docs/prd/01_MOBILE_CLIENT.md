# PRD: Mobile Client - UX & Interaction Design

## 1. Introduction
This document serves as the comprehensive guide for the UX/UI design of the RunningCoach mobile application. It translates the "Holistic Coach" vision into concrete screens, prioritizing clarity, trust, and readiness assessment.

**Target Audience:** UX Researchers, UI Designers, Frontend Engineers.
**Goal:** Create a "High-Fidelity" blueprint for Figma prototyping.

## 2. Information Architecture

The application uses a **Bottom Navigation Bar** structure with 4 core tabs (Simplified from 5):
1.  **Today:** The daily command center. Readiness, workout of the day, immediate actions.
2.  **Plan:** The forward-looking calendar. Schedule management, phase visualization.
3.  **Progress:** Long-term analytics. ACWR, TSB, injury risk monitoring.
4.  **Library:** Educational content. Strength routines, drills, nutrition guides.
5.  **You:** Profile, settings, device management.

## 3. Onboarding & Setup Flow

### 3.1. Welcome & Value Prop
*   **Screen:** Minimalist carousel.
    *   "Your Private Coach."
    *   "We listen to your body."
    *   "We adapt to your life."
*   **Action:** "Start Training"

### 3.2. Baseline Data Collection
*   **Input Fields:**
    *   Current Times (5K/10K/HM/M).
    *   Weekly Mileage.
    *   **Injury History:** Critical for the "Skeletal" readiness baseline.
    *   **Life Constraints:** "I travel monthly", "I have kids" (Informs the "Life-Aware" engine).
    *   **Goal:** Race Date & Target Time.

### 3.3. Permission Priming
*   **Critical:** "To be your coach, we need to see your data."
*   **HealthKit/Garmin:** Mandatory for the "Holistic" engine.

---

## 4. Core Navigation Tabs

### 4.1. Tab 1: "Today" (Dashboard)
**Purpose:** The "at a glance" view of body readiness and today's directive.

**UI Structure:**
1.  **Header:** Date | Phase (e.g., "Build Phase - Week 4").
2.  **Hero Card: Body System Scan**
    *   **Visual:** A stylized human body outline with 4 key zones highlighted.
    *   **Zones & Status:**
        *   🫁 **Cardio:** Green/Yellow/Red (Based on HRV/RHR).
        *   🦵 **Muscles:** Green/Yellow/Red (Based on soreness/volume).
        *   🦴 **Skeleton:** Green/Yellow/Red (Based on ACWR/Impact).
        *   🧠 **CNS:** Green/Yellow/Red (Based on Sleep/Stress).
    *   **Overall Status:** "All Systems Go" or "CNS Fatigue Detected".
3.  **Primary Card: The Directive**
    *   **Content:**
        *   **Action:** "Run Long" / "Rest" / "Yoga".
        *   **Details:** "15km @ 5:30/km".
        *   **The 'Why':** "Your skeletal load is low, so we're pushing distance today."
    *   **Actions:** "Start", "Mark Complete", "Pair Watch".
4.  **Secondary Card: Fueling**
    *   **Content:** "Carb Target: 300g".
    *   **Context:** "Fueling for tomorrow's long run."

### 4.2. Tab 2: "Plan" (Calendar)
**Purpose:** Visualization of the training journey and schedule management.

**UI Structure:**
1.  **View:** Week (Default) / Month.
2.  **"Life Happens" Button:**
    *   **Menu:** "I'm Sick", "I'm Traveling", "I'm Tired".
    *   **Logic:**
        *   "Sick" -> Triggers "Return to Health" protocol (removes workouts for 3 days).
        *   "Traveling" -> Suggests "Maintenance Mode" (short, high-intensity).
3.  **Dynamic Updates:** If a user drags a workout, the system warns: "Moving this here increases injury risk to High."

### 4.3. Tab 3: "Progress" (Analytics)
**Purpose:** Long-term tracking of adaptation and injury risk.

**UI Structure:**
1.  **Chart 1: Injury Risk (ACWR)**
    *   **Visual:** Line chart showing the "Safe Zone" (0.8 - 1.3).
    *   **Goal:** Keep the line in the green.
2.  **Chart 2: Fitness vs. Fatigue**
    *   **Visual:** TSB Chart.
3.  **Metric: Personal Bests**
    *   **List:** 5K, 10K, HM, Marathon.
    *   **Projected:** "Predicted Marathon Time: 3:45:00".

### 4.4. Tab 4: "Library" (Resources)
**Purpose:** Educational content and auxiliary training tools.

**UI Structure:**
1.  **Strength & Prehab:**
    *   **Routines:** "Core for Runners", "Hip Mobility".
    *   **Focus:** Injury prevention.
2.  **Nutrition:**
    *   **Guides:** "Race Week Carbo-Loading".
3.  **Drills:**
    *   **Videos:** Form correction drills.

### 4.5. Tab 5: "You" (Profile)
**Purpose:** Settings and device management.

**UI Structure:**
1.  **User Profile:** HR Zones, Weight.
2.  **Integrations:** Garmin/HealthKit status.
3.  **Subscription:** Manage plan.

---

## 5. Key Interaction Flows

### 5.1. Morning Check-In (The "Scan")
*   **Trigger:** Morning notification.
*   **Screen:** "How do you feel?"
*   **Input:**
    *   Sleep Quality (1-10).
    *   Soreness Map (Tap body parts).
    *   Stress Level (1-10).
*   **Result:** Updates the "Body System Scan" on the Dashboard.

### 5.2. Post-Workout RPE
*   **Trigger:** After workout.
*   **Input:** RPE (1-10).
*   **Result:** Updates "Muscular" and "CNS" fatigue scores.

### 5.3. Injury Reporting
*   **Entry:** "I have pain."
*   **Input:** Location, Intensity.
*   **Result:** Immediate plan adaptation (e.g., switch Run to Swim).

---

## 6. Offline-First Capabilities
The app functions 100% offline.
*   **Cached Plan:** Next 4 weeks always available.
*   **Local Logging:** RPE and check-ins save locally and sync when online.

## 7. Design System Guidelines
*   **Aesthetic:** Clean, Medical/Scientific, Premium.
*   **Colors:** White, Black, Navy, Signal Green/Yellow/Red.
*   **Typography:** Highly readable, Swiss style.

