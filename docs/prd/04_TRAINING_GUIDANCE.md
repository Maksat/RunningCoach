# PRD: Training Guidance & Adaptive Logic

## 1. Introduction
This document defines the core logic for the RunningCoach training engine. It details how the system generates workouts, adapts to user feedback and life events, and provides real-time guidance. The goal is to build a "brain" that mimics a knowledgeable, evidence-based human coach: structured enough to drive adaptation, but flexible enough to handle real life.

## 2. Scientific Core Principles
The training engine is built on three non-negotiable scientific pillars (see `Initial research.md`):

1.  **Polarized/Pyramidal Distribution:** Approximately 80% of training volume is at low intensity (Zone 1/2), with 20% at high intensity. This prevents "black hole" training (moderately hard all the time) which causes fatigue without optimal adaptation.
2.  **Periodization:** Training follows macro-cycles:
    *   **Base:** Aerobic volume + Strength foundation.
    *   **Build:** Specificity (Threshold/VO2max) + Peak volume.
    *   **Taper:** Exponential volume reduction (40-60%) while maintaining intensity.
3.  **Workout Hierarchy:** When life forces compromises, we prioritize based on physiological impact:
    1.  **Long Run:** Critical for mitochondrial density and musculoskeletal resilience.
    2.  **Tempo/Threshold:** Metabolic efficiency.
    3.  **Intervals:** VO2max (least critical for marathon success vs. others).
    4.  **Easy Runs:** Volume fillers (first to go when time is tight).

## 3. Adaptive Logic (The "Brain")

### 3.1. The Traffic Light System (Daily Readiness)
Before every workout, the system evaluates readiness using a multi-factor algorithm.

*   **Inputs:**
    *   **Resting Heart Rate (RHR):** vs. 30-day baseline.
    *   **HRV (if available):** vs. 30-day baseline.
    *   **Sleep Score:** (Duration × Quality).
    *   **Subjective Soreness:** (1-10).
    *   **Previous Day's Load:** (RPE × Duration).

*   **Outputs:**
    *   🟢 **Green Light:** Proceed as planned.
    *   🟡 **Yellow Light:** Caution.
        *   *Logic:* If scheduled workout is Interval/Tempo -> Reduce intensity by 5-10% OR volume by 20%.
        *   *User Message:* "Your recovery is slightly off. Let's dial back the intensity today to keep you healthy."
    *   🔴 **Red Light:** Stop.
        *   *Logic:* Convert any run to "Recovery" (Zone 1, max 45 mins) or suggest complete Rest/Mobility.
        *   *User Message:* "High fatigue detected. Training hard today risks injury. Take a rest day or a very light jog."

### 3.2. Handling Missed Workouts (Dynamic Rescheduling)
The system **NEVER** simply "pushes" workouts forward, creating a "bow wave" of uncompleted tasks. It adapts:

*   **Scenario A: Missed Easy Run**
    *   *Action:* Skip it. Do not make it up.
    *   *Rationale:* Volume loss is negligible.
*   **Scenario B: Missed Quality Session (Intervals/Tempo)**
    *   *Action:* Move to next available day, *replacing* an easy run. Ensure 48h buffer before next hard session.
    *   *Constraint:* If moving it clashes with the Long Run (e.g., moved to Friday, Long Run is Saturday), **cancel the Quality Session**. The Long Run takes priority.
*   **Scenario C: Missed Long Run**
    *   *Action:* If < 2 days passed, do it now. If > 2 days, skip it and resume plan.
    *   *Critical Rule:* Never do a Long Run and a Hard Workout back-to-back.

### 3.3. Handling "Extra" Unplanned Activity
Users have lives (hiking, moving house, pickup basketball).
*   **Input:** User logs "Manual Activity" with RPE and Duration.
*   **Logic:** System calculates Acute Load impact.
*   **Adaptation:** If Acute Load spikes > 1.5 ACWR, the next 2-3 days of training are automatically downgraded to Easy/Recovery to dampen the spike.

### 3.4. Illness & Injury Protocols
*   **"Neck Check" Rule:**
    *   *Symptoms above neck (runny nose):* Allow Easy Run (Yellow Light).
    *   *Symptoms below neck (fever, chest, aches):* **MANDATORY REST** (Red Light).
*   **Return to Run:**
    *   After >3 days off: Reduce volume by 30% for first week.
    *   After >7 days off: Step back 2 weeks in the macro-cycle.

## 4. Workout Types & Execution Guidance

### 4.1. Long Run
*   **Goal:** Time on feet, fat oxidation, mental resilience.
*   **Guidance:**
    *   "Keep it conversational. If you can't speak in sentences, you're going too fast."
    *   **Fueling Alerts:** Every 45 mins: "Take a gel/chew now." (Configurable).
    *   **Form Check:** Every 30 mins: "Check your shoulders. Are they relaxed?"

### 4.2. Recovery Run
*   **Goal:** Blood flow, aerobic maintenance without stress.
*   **Guidance:**
    *   **Strict Cap:** If HR > Zone 2 for > 1 min -> Audio Alert: "Slow down! Recovery runs must be easy."
    *   "Embrace the slow. This run makes you faster tomorrow."

### 4.3. Tempo / Threshold
*   **Goal:** Increase lactate clearance.
*   **Guidance:**
    *   "Comfortably hard. 7-8/10 effort."
    *   **Pacing:** Audio feedback on split times vs. target.

### 4.4. Intervals (VO2max)
*   **Goal:** Max aerobic capacity.
*   **Guidance:**
    *   **Countdown:** "3, 2, 1, GO!" / "3, 2, 1, REST."
    *   **Motivation:** "Strong finish!"

## 5. User Experience Features

### 5.1. The "Coach's Note"
Every day, the UI displays a generated text explaining the *Why*:
*   *Example:* "We're doing 400m repeats today to boost your top-end speed. It's a Green Light day, so give it your best effort!"
*   *Example:* "I've switched today to a Rest Day because your sleep score was low (45). Recovery is when you get stronger."

### 5.2. Post-Workout Feedback Loop
Immediately after finishing, ask:
1.  **RPE (0-10):** "How hard was that?" (Calibrates Load).
2.  **Feeling:** "Strong" / "Normal" / "Weak/Tired".
3.  **Pain/Niggle:** "Any pain?" -> If Yes, prompt for location/severity -> Triggers Injury Protocol if persistent.

### 5.3. Audio & Haptic Cues
*   **Philosophy:** "Eyes up, phone away."
*   **Haptics:** Distinct vibration patterns for "Speed Up", "Slow Down", and "Interval Start/End".
*   **Audio:** Text-to-speech updates on distance, pace, and HR every 1km/1mi.

## 6. Integration with Other PRDs
*   **[07_LOAD_MANAGEMENT.md](./07_LOAD_MANAGEMENT.md):** Provides the ACWR math used in Adaptive Logic.
*   **[08_STRENGTH_PLYOMETRICS.md](./08_STRENGTH_PLYOMETRICS.md):** Strength sessions are treated as "Workouts" with Load scores.
*   **[03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md):** Source of HR/HRV data.
