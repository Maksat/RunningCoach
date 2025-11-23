# PRD: Adaptive Training Engine & Guidance

## 1. Introduction
This document defines the core intelligence system that differentiates RunningCoach from static training plans. The Adaptive Training Engine is the "brain" that translates individual readiness, response patterns, and life circumstances into daily training prescriptions, combined with real-time guidance during workout execution.

## 2. Research Foundation
*   **HRV-Guided Training:** Produces 50% high responders vs. 29% for predetermined plans, with 6.2% performance improvement vs. 2.9% for fixed programs
*   **Responder Classification:** No evidence supports "global non-responders"—non-response is measure-specific and stimulus-specific
*   **Multi-Criteria Decisions:** Single-metric decisions are unreliable; combine 4-5 readiness markers for robust daily prescriptions
*   **Polar/Pyramidal Distribution:** ~80% of training volume at low intensity (Zone 1/2), 20% at high intensity to prevent "black hole" training
*   **Periodization:** Evidence-based macro-cycles (Base → Build → Peak → Taper) drive optimal adaptation

## 3. Core Components

### 3.1. Baseline Establishment (Weeks 1-4)
*   **Purpose:** Establish individual normal ranges before making training adjustments
*   **HRV Baseline:** 4-week rolling average ± 0.5 SD (when available)
*   **Resting HR Baseline:** 4-week rolling average ± 1 SD
*   **Subjective Wellness:** Identify personal patterns in recovery, sleep quality, soreness
*   **Performance Baseline:** Initial fitness tests (e.g., 5K time trial, lactate threshold test)
*   **No Adaptations:** During this period, follow conservative predetermined plan to gather data

### 3.2. Traffic Light Decision System
Daily readiness check integrating 4-5 markers to determine training prescription adjustment.

#### Green Light (Proceed as Planned)
*   HRV within normal range (± 0.5 SD of baseline) OR unavailable
*   Morning recovery rating ≥ 5/10
*   Previous workout completed successfully
*   Sleep index ≥ 40 (sleep quality × duration)
*   Muscle soreness ≤ 5/10
*   **Warm-up HR:** Normal range (within ±5 bpm of baseline for same pace)
*   **Action:** Execute planned workout without modification

#### Yellow Light (Modify Workout)
*   1-2 markers outside normal range
*   Previous workout struggled but completed
*   Moderate fatigue (4-5/10)
*   **Warm-up HR:** Elevated (+5-10 bpm above baseline) or significant decoupling (>5%)
*   Mild illness symptoms (above neck only)
*   **Modifications:**
    *   Reduce intensity by 5-10% OR reduce volume by 20% (maintain one dimension)
    *   Convert high-intensity intervals to steady tempo pace
    *   Reduce interval repetitions while maintaining intensity
    *   Shorten long run by 20% while maintaining easy pace

#### Red Light (Recovery Day Only)
*   3+ markers outside normal range
*   Failed previous workout despite adequate effort
*   High fatigue (≥ 6/10)
*   Poor sleep quality for 2+ consecutive nights
*   Illness symptoms below neck (chest congestion, body aches, fever)
*   **Action:**
    *   Easy running only at conversational pace for max 60 minutes
    *   Complete rest day
    *   Active recovery (walking, easy swimming, gentle mobility)

### 3.3. Workout Hierarchy & Redistribution Logic
When workouts must be missed or rescheduled due to life circumstances:

**Priority Ranking:**
1. **Long Runs:** Highest priority—missing >1 compromises marathon-specific endurance. Critical for mitochondrial density and musculoskeletal resilience.
2. **Threshold/Tempo Runs:** Build metabolic foundation for marathon pace. Improve lactate clearance efficiency.
3. **Interval Sessions:** Develop VO2max and speed (least critical for marathon success).
4. **Easy Runs:** Most flexible—can be shortened, skipped, or replaced with cross-training. Volume fillers.

**Redistribution Rules:**
*   **Missed <3 days:** Continue planned progression
*   **Missed 3-7 days:** Repeat previous week's training load rather than progressing
*   **Missed >7 days:** Step back two weeks in plan to rebuild safely
*   **Never "make up" workouts:** Don't cram missed sessions into remaining days (spikes acute load dangerously)

**Within-Week Rescheduling:**
*   Maintain ≥48 hours between quality sessions
*   If quality workout must shift to day before long run, convert to easy run
*   Allow workout swapping but preserve weekly load and intensity distribution

**Specific Scenarios:**
*   **Missed Easy Run:** Skip it, do not make it up (volume loss negligible)
*   **Missed Quality Session (Intervals/Tempo):** Move to next available day, replacing an easy run. If clashes with Long Run (e.g., moved to Friday, Long Run Saturday), cancel the quality session. Long run takes priority.
*   **Missed Long Run:** If <2 days passed, do it now. If >2 days, skip and resume plan. Never do Long Run and Hard Workout back-to-back.

### 3.4. Unplanned & Extra Activity Handling
The engine must account for all physical stress, not just prescribed running.

**Extra Activity Logic:**
*   **Detection:** Ingest activities from wearables (e.g., "Soccer", "Hiking", "Cycling") or manual entry.
*   **Load Conversion:** Convert to Training Load Units (TLU) = RPE × Duration (minutes).
*   **Impact Assessment:**
    *   If Extra Load < 25% of tomorrow's planned load: **No Change** (absorb variance).
    *   If Extra Load 25-50% of tomorrow's planned load: **Minor Adjustment** (reduce tomorrow's volume by 10-20%).
    *   If Extra Load > 50% of tomorrow's planned load: **Major Adjustment** (reduce tomorrow's volume by 20-40% or convert to recovery).
*   **Example:** User plays 90 mins soccer (RPE 7) = 630 TLU. Planned run tomorrow is 60 mins easy (RPE 3) = 180 TLU. Extra load is >300% of planned. **Action:** Cancel run, assign Rest/Recovery.

### 3.5. Failed Workout Protocols
Systematic response to subpar workout performance:

**Single Poor Workout:**
*   Monitor but no immediate plan change
*   Evaluate external factors (heat, sleep, stress)
*   Continue with next planned workout

**Two Consecutive Poor Quality Sessions:**
*   Accumulated fatigue indicated
*   Reduce volume by 25% for next week
*   Attempt to maintain prescribed intensities if possible

**Three+ Consecutive Substandard Workouts:**
*   Demand full recovery week at 50-75% normal volume
*   Regardless of training cycle position
*   Return to previous intensity gradually

**Workout-Specific Responses:**

*Intervals:*
*   First 2-3 intervals hit target then fade → Reduce total intervals by 25-50%
*   Off-pace from start → Convert to tempo pace for planned duration
*   Cannot sustain any quality → Abort, convert to easy running, prioritize recovery

*Tempo Runs:*
*   Cannot hit prescribed pace → Reduce by 5-10 seconds/mile, maintain duration
*   Still struggling → Convert entirely to easy running

*Long Runs:*
*   Maintain duration even if pace is slower (time on feet matters most)
*   Only reduce by 20% if excessive fatigue
*   Cannot complete 70% of planned distance → Need recovery week

### 3.6. Illness & Injury Protocols

**"Neck Check" Rule:**
*   **Symptoms above neck** (runny nose, scratchy throat): Allow Easy Run (Yellow Light).
*   **Symptoms below neck** (fever, chest congestion, aches): **MANDATORY REST** (Red Light).

**Return to Run:**
*   After >3 days off: Reduce volume by 30% for first week.
*   After >7 days off: Step back 2 weeks in the macro-cycle.
*   Follow 5-stage graduated protocol (see [09_CROSS_TRAINING_REHAB.md](./09_CROSS_TRAINING_REHAB.md))

### 3.7. Responder Classification & Adaptation
Track individual adaptation to training stimuli over 8-12 weeks:

**Classification Criteria:**
*   Technical error of measurement: 4-5% for key performance markers
*   **Key Inputs:** VO2Max trends, Threshold Pace evolution, HR/Pace efficiency
*   **High Responders:** Improvements >8-10% (2× technical error)
*   **Moderate Responders:** Improvements 2-10% (0.5-2× technical error)
*   **Low Responders:** Changes <2% (below 0.5× technical error)

**Modality-Specific Adjustments:**
*   Non-response to endurance volume → Increase intensity
*   Non-response to intensity → Increase volume
*   Non-response to running → Add cross-training or strength training
*   Monitor multiple performance markers (economy, threshold pace, VO2max proxy)

**Variable Importance Personalization:**
*   Start monitoring 8-10 variables broadly
*   After 8-12 weeks, identify top 5 most predictive markers per athlete
*   Some respond primarily to HRV, others to sleep quality, others to mood/load patterns
*   Adjust decision weights based on individual response patterns

### 3.8. Progression Algorithms

**Conservative Progression (injury-prone, returning from break):**
*   Increase week-to-week load by 3-5%
*   Recovery week every 4th week (60-70% of week 3 load)
*   ACWR maintained between 0.8-1.3, red flags at 1.5+
*   Daily readiness monitoring

**Moderate Progression (typical healthy athletes):**
*   Increase week-to-week load by 5-10%
*   Recovery week every 3rd-4th week (50-60% of previous week)
*   ACWR maintained between 0.8-1.5, red flags at 1.8+
*   Standard monitoring

**Aggressive Progression (well-adapted, time-constrained):**
*   Increase week-to-week load by 10-15%
*   Recovery week every 3rd week (60% of week 2)
*   Close monitoring for warning signs
*   ACWR up to 1.5 acceptable, flag anything >2.0

### 3.9. Recovery Prediction (ML Phase)
After collecting 12-16+ weeks of data:

*   Train LASSO regression model predicting next-day recovery
*   Input variables: training load, HRV, sleep, soreness, stress, mood, previous day recovery
*   Output: Predicted recovery score with confidence interval
*   Identify top 5 variables per athlete using variable importance algorithms
*   Continuous feedback loop refining model with actual outcomes
*   Adjust training recommendations proactively based on predicted recovery

### 3.10. Environmental & Terrain Normalization
The engine normalizes performance data to ensure fair comparisons and safe prescriptions.

**Weather Adjustments (Heat & Humidity):**
*   **Logic:** Use Dew Point or Wet Bulb Globe Temperature (WBGT) if available.
*   **Thresholds:**
    *   Dew Point < 60°F (15°C): No adjustment.
    *   Dew Point 60-70°F (15-21°C): Adjust pace targets slower by 1-3%.
    *   Dew Point 70-75°F (21-24°C): Adjust pace targets slower by 3-6%.
    *   Dew Point > 75°F (24°C): Adjust pace targets slower by >6% OR switch to Heart Rate/RPE targets only.
*   **Safety:** If WBGT > 82°F (28°C), issue "High Heat" warning and recommend shortening duration or moving to treadmill.

**Terrain & Elevation (Hills):**
*   **Metric:** Use **Grade Adjusted Pace (GAP)** for all effort calculations on non-flat routes.
*   **Prescription:**
    *   *Hilly Route:* Prescribe effort by Power (Watts) or Heart Rate, not raw pace.
    *   *Downhill:* Monitor eccentric load (impact). If descent > 500m in a session, increase recovery time estimate by 10-20%.

**Altitude Acclimatization:**
*   **Detection:** Significant change in baseline altitude (>3000ft/1000m increase).
*   **Protocol:**
    *   **Days 1-3:** "Arrival Mode" - Cap intensity at Zone 2. Reduce volume by 25%.
    *   **Days 4-7:** "Acclimatization" - Reintroduce intensity but adjust pace targets slower by 3-5% per 1000ft above 3000ft.
    *   **Day 14+:** Return to normal adaptive logic (new baseline established).

### 3.11. Goal Proximity & "Push" Logic
The engine's risk tolerance and "push" factor change as the goal event approaches.

**Phase 1: Foundation (>12 weeks out)**
*   **Focus:** Consistency and injury prevention.
*   **Risk Tolerance:** Very Low.
*   **Flexibility:** High. Missed workouts are easily absorbed.
*   **Push Factor:** Low. Prioritize feeling good over hitting splits.

**Phase 2: Crunch Time (8-12 weeks out)**
*   **Focus:** Metabolic specificity (Threshold/VO2Max).
*   **Risk Tolerance:** Low-Moderate.
*   **Flexibility:** Moderate. Key sessions (Long Run, Tempo) are "Anchors" - hard to move/skip.
*   **Push Factor:** Moderate. If user is slightly behind, engine may suggest "Focus Weeks" with slightly higher density, provided readiness is Green.

**Phase 3: Critical Zone (2-8 weeks out)**
*   **Focus:** Race specific endurance and confidence.
*   **Risk Tolerance:** Moderate (calculated risks).
*   **Flexibility:** Low.
*   **Push Factor:** High ("Meaningful Push").
    *   *Scenario:* User is 5% off goal pace target.
    *   *Action:* Engine prescribes "Test Sessions" (e.g., 10k at goal marathon pace).
    *   *Feedback:* If test fails, engine **honestly** advises goal adjustment (e.g., "Aim for 3:45 instead of 3:30"). It does NOT force unsafe training to catch up.
    *   *Override:* If readiness is "Yellow" but it's a critical key session, engine might prompt: "This is a key session. If you feel capable, proceed with caution, otherwise shorten by 15%." (Slightly more permissive than Foundation phase).

## 4. Workout Types & Execution Guidance

### 4.1. Long Run
*   **Physiological Goal:** Time on feet, fat oxidation, mental resilience, mitochondrial density
*   **Execution Guidance:**
    *   "Keep it conversational. If you can't speak in sentences, you're going too fast."
    *   **Fueling Alerts:** Every 45 mins: "Take a gel/chew now." (Configurable).
    *   **Form Check:** Every 30 mins: "Check your shoulders. Are they relaxed?"
    *   **Pace Expectation:** Slower than marathon pace; focus on duration not speed
*   **Modifications:**
    *   Yellow Light: Reduce by 20% while maintaining easy pace
    *   Red Light: Skip or convert to recovery walk/cross-training

### 4.2. Recovery Run
*   **Physiological Goal:** Blood flow, aerobic maintenance without stress
*   **Execution Guidance:**
    *   **Strict Cap:** If HR > Zone 2 for > 1 min → Audio Alert: "Slow down! Recovery runs must be easy."
    *   "Embrace the slow. This run makes you faster tomorrow."
    *   **Pace Expectation:** 60-90 seconds slower than marathon pace
*   **Modifications:**
    *   Yellow Light: Reduce duration by 25% or convert to walk
    *   Red Light: Skip entirely or easy walk only

### 4.3. Tempo / Threshold
*   **Physiological Goal:** Increase lactate clearance, build metabolic efficiency
*   **Execution Guidance:**
    *   "Comfortably hard. 7-8/10 effort."
    *   **Pacing:** Audio feedback on split times vs. target.
    *   **Feel Check:** Should be sustainable for 45-60 minutes if needed
*   **Modifications:**
    *   Yellow Light: Reduce pace by 5-10 seconds/mile OR reduce duration 20%
    *   Red Light: Convert to easy run

### 4.4. Intervals (VO2max)
*   **Physiological Goal:** Max aerobic capacity development
*   **Execution Guidance:**
    *   **Countdown:** "3, 2, 1, GO!" / "3, 2, 1, REST."
    *   **Motivation:** "Strong finish!"
    *   **Pace Management:** Hit target pace by interval 2-3, not interval 1
*   **Modifications:**
    *   Yellow Light: Reduce total intervals by 25-50%, maintain intensity
    *   Red Light: Convert to steady tempo or easy run

## 5. User Experience Features

### 5.1. The "Coach's Note"
Every day, the UI displays a generated text explaining the *Why*:
*   *Example Green Light:* "We're doing 400m repeats today to boost your top-end speed. It's a Green Light day, so give it your best effort!"
*   *Example Red Light:* "I've switched today to a Rest Day because your sleep score was low (45). Recovery is when you get stronger."
*   *Example Yellow Light:* "Your recovery is slightly off. Let's dial back the intensity today to keep you healthy—running the tempo run at easy pace instead."

**Tone:** Mild, non-intrusive, educational. Explain the reasoning, not just the prescription.

### 5.2. Post-Workout Feedback Loop
Immediately after finishing, ask:
1.  **RPE (0-10):** "How hard was that?" (Calibrates Load).
2.  **Feeling:** "Strong" / "Normal" / "Weak/Tired".
3.  **Pain/Niggle:** "Any pain?" → If Yes, prompt for location/severity → Triggers Injury Protocol if persistent.

**Importance:** This feedback refines future prescriptions and catches early injury warnings.

### 5.3. Audio & Haptic Cues
*   **Philosophy:** "Eyes up, phone away."
*   **Haptics:** Distinct vibration patterns for "Speed Up", "Slow Down", and "Interval Start/End".
*   **Audio:** Text-to-speech updates on distance, pace, and HR every 1km/1mi or user-configured interval.
*   **Alerts:** "You're running too fast for a recovery run—slow down to Zone 2."

## 6. Phase-Specific Adaptations

### 6.1. Base Building (8-12 weeks)
*   Establish aerobic capacity and structural resilience
*   70-75% training at easy intensity
*   Long runs progress from 60 min → 2 hours by phase end
*   Strength training 2-3×/week (optimal window before higher running volume)
*   Recovery weeks every 3-4 weeks with 20-25% volume reduction

### 6.2. Build (12-16 weeks)
*   Introduce race-specific intensities
*   Maintain 80/20 intensity distribution (easy/hard)
*   Peak weeks 2-4 weeks before taper (≤30% above chronic load baseline)
*   Recovery weeks remain critical every 3-4 weeks

### 6.3. Peak (Final 2-4 weeks before taper)
*   Highest training loads
*   Test accumulated fitness
*   Must not exceed chronic load +30%
*   Monitor readiness closely

### 6.4. Taper (1-2 weeks before race)
*   Reduce volume by 20-30% while maintaining intensity
*   Shorten quality session durations, not eliminate them
*   ACWR naturally decreases toward 0.8 (expected and beneficial)
*   HRV should increase—if it doesn't, may indicate overtraining or subclinical illness

## 7. Decision-Making Hierarchy
1. **Safety First:** Hard limits preventing dangerous load spikes or training through illness
2. **Optimization Second:** ML-driven fine-tuning of loads within safe ranges
3. **User Preference Third:** Respect athlete goals, schedule constraints, training philosophy
4. **Communication Always:** Explain *why* recommendations occur, educate athletes

## 8. Integration Points
*   **Load Management System** ([07_LOAD_MANAGEMENT.md](./07_LOAD_MANAGEMENT.md)): Receives ACWR, TSB, monotony calculations
*   **Backend Core** ([02_BACKEND_CORE.md](./02_BACKEND_CORE.md)): Hosts the computation engine
*   **Mobile Client** ([01_MOBILE_CLIENT.md](./01_MOBILE_CLIENT.md)): Displays recommendations and collects readiness data
*   **Wearable Integration** ([03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md)): Ingests HRV, HR, activity data
*   **Strength & Plyometrics** ([08_STRENGTH_PLYOMETRICS.md](./08_STRENGTH_PLYOMETRICS.md)): Strength sessions treated as workouts with load scores
*   **Cross-Training** ([09_CROSS_TRAINING_REHAB.md](./09_CROSS_TRAINING_REHAB.md)): Cross-training equivalency and injury protocols

## 9. Success Metrics
*   **Responder Rate:** Target <5% non-responders (vs. 21% for predetermined plans)
*   **Recommendation Adherence:** Users follow adaptive recommendations ≥80% of time
*   **Prediction Accuracy:** Next-day recovery predictions within ±1 point on 10-point scale
*   **Injury Prevention:** Interventions triggered before ACWR exceeds 1.5 for 2+ consecutive weeks
*   **Workout Completion Quality:** ≥85% of prescribed workouts completed at target intensity/duration (with intelligent adaptations counted as successful)
