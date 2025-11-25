# PRD: Load Management & ACWR System

## 1. Introduction
This document defines the load management and monitoring system that forms the foundation of RunningCoach's injury prevention approach. Research shows ACWR above 1.5 produces **4-fold injury increases**, making this the most critical safety system in the application.

## 2. Research Foundation
*   **ACWR Sweet Spot:** 0.8-1.3 represents optimal range for adaptation without injury
*   **High Risk:** ACWR >1.5 for two consecutive weeks demands immediate intervention
*   **10% Rule Debunked:** No injury difference between 10% and 50% weekly increases; the issue is acute spike patterns, not absolute weekly changes
*   **Recovery Weeks:** Muscle damage markers (creatine kinase) drop 59% during recovery weeks while fitness remains stable for up to 2 weeks

## 3. Core Metrics

### 3.1. Session RPE × Duration (Internal Load)
**Primary load metric** for all activities:

*   **Calculation:** RPE (0-10 scale) × session duration (minutes)
*   **Collection:** 20-30 minutes post-workout for accuracy (not during workout)
*   **Example:** 60-minute run rated 6/10 effort = 360 training load units
*   **Applies To:** All activities including strength, cross-training, unplanned activities

**Why Session RPE:**
*   Works without expensive equipment
*   Accounts for internal response (heat, fatigue, illness affect RPE even at same pace)
*   Validated across multiple sports and populations
*   Captures total stress including environmental and psychological factors

### 3.2. Acute Load (7-Day Rolling Average)
*   **Definition:** Average daily training load over previous 7 days
*   **Represents:** Fatigue and recent training stress
*   **Calculation:** Exponentially weighted moving average (EWMA) with 7-day window
*   **Weight:** Recent days weighted more heavily than older days

### 3.3. Chronic Load (28-Day Rolling Average)
*   **Definition:** Average daily training load over previous 28 days (4 weeks)
*   **Represents:** Fitness and training adaptation level
*   **Calculation:** EWMA with 28-day window
*   **Stability:** Changes slowly, providing baseline fitness reference

### 3.4. Acute-to-Chronic Workload Ratio (ACWR)
*   **Calculation:** Acute Load ÷ Chronic Load
*   **Update Frequency:** Calculate daily, evaluate weekly for trends
*   **Display:** 4-week trend with color-coded zones

**Risk Zones:**
*   **Green (0.8-1.3):** Sweet spot—optimal adaptation, lowest injury risk
*   **Low Yellow (0.5-0.8):** Insufficient stimulus for continued adaptation (detraining risk)
*   **High Yellow (1.3-1.5):** Moderate risk—monitor closely
*   **Red (>1.5):** High danger zone—4× injury risk, immediate intervention required

### 3.5. Training Stress Balance (TSB)
*   **Calculation:** Yesterday's Chronic Load - Acute Load
*   **Represents:** Form and race readiness
*   **Interpretation:**
    *   Positive values → Freshness (good for racing)
    *   Negative values → Accumulated fatigue (normal during training)
    *   Values < -20 → Concerning fatigue accumulation
    *   Values < -30 → Demand intervention

**Target TSB by Phase:**
*   Base/Build: -5 to -15 (productive training)
*   Peak weeks: -15 to -25 (pushing fitness)
*   Taper: Moving toward 0 to +10
*   Race day: +10 to +25 (marathon-specific, athlete-dependent)

### 3.6. Training Monotony
*   **Calculation:** Weekly mean training load ÷ weekly standard deviation
*   **Risk Threshold:** Values >2.0 signal dangerous lack of variation
*   **Single Run Spike:** Planned run >10% longer than any run in last 30 days = 64% higher injury risk
*   **Danger Pattern:** High monotony + high absolute load = dramatically increased overtraining risk

**Mitigation:**
*   Vary training throughout each week (intensities, durations, activities)
*   Never run identical sessions day after day
*   Include true easy days, not just "moderately hard" every day
*   Integrate different workout types (intervals, tempo, long, easy, strength, cross-training)

## 4. Data Collection

### 4.1. Activity Data Sources
*   **Wearable Auto-Import:** GPS distance, duration, heart rate, pace (when available)
*   **Manual Entry:** Required for activities without watch (gym, pool, bike, etc.)
*   **Unplanned Activities:** System prompts user to log unexpected activities (manual labor, hiking, sports)

### 4.2. Session RPE Collection
*   **Timing:** 20-30 minutes post-workout (optimal for accuracy)
*   **Method:** 0-10 scale with visual reference and descriptions
*   **Notification:** Auto-trigger reminder 25 minutes after activity ends
*   **Required:** Cannot be skipped—critical for load calculations
*   **Scale Reference:**
    *   0 = Rest
    *   1-2 = Very easy
    *   3-4 = Easy
    *   5-6 = Moderate
    *   7-8 = Hard
    *   9-10 = Maximal

### 4.3. External Load (When Available)
*   Distance (km/miles)
*   Duration (minutes)
*   Pace (min/km or min/mile)
*   Elevation gain
*   Heart rate data (average, max, zones)

**Training Efficiency Index:**
*   External load (distance × average pace) ÷ Internal load (RPE × duration)
*   Track trends over 2-4 week windows
*   Improving efficiency = same external load requires lower RPE (fitness improving)
*   Declining efficiency = same external load requires higher RPE (fatigue accumulating)

## 5. Intervention Logic

### 5.1. Immediate Reduction Triggers (Any One Present)
*   Acute injury or illness
*   HRV below baseline -2 SD for 2+ consecutive days
*   Morning recovery <4/10 for 3+ consecutive days
*   Performance drop >10% in standardized test
*   Single Run Spike >20% (Doubling risk)
*   TSB < -30
*   **Action:** Reduce to recovery week protocols (40-60% normal load), prioritize sleep/nutrition, medical evaluation if needed

### 5.2. Moderate Concern Triggers (Any Two Present)
*   Sleep index <40 for 3+ days (quality × duration)
*   Muscle soreness >7/10 for 2+ days
*   Training monotony >2.5 for 7+ days
*   ACWR outside 0.8-1.5 range
*   Single Run Spike 10-20%
*   Mood disturbance increasing for 7+ days
*   **Action:** Reduce intensity 20-30%, maintain or reduce volume 15%, add extra recovery day in next microcycle

### 5.3. ACWR-Specific Interventions

**ACWR >1.5 (First Occurrence):**
*   Flag as yellow warning
*   Display explanation to athlete
*   Recommend reducing next week's volume by 10-15%
*   Monitor closely

**ACWR >1.5 (Two Consecutive Weeks):**
*   Flag as red alert
*   Mandatory reduction: Immediate recovery week at 50% load
*   Explanation of 4× injury risk
*   Cannot be overridden without explicit acknowledgment

**ACWR >1.8:**
*   Critical alert
*   Immediate 50% load reduction
*   Convert all workouts to easy pace only
*   Coach notification (if applicable)

**ACWR <0.8 (Two Consecutive Weeks):**
*   Detraining risk warning
*   Recommend increasing load by 10-15% if readiness markers permit
*   Ensure chronic illness/fatigue not suppressing load

### 5.4. Recovery Week Protocols
Triggered every 3-4 weeks proactively OR reactively when intervention criteria met:

*   Overall volume: 50-75% of previous week (depending on severity)
*   Long run: Reduce by 40-50% regardless of experience level
*   Quality sessions: Reduce total intervals by 25-50%, maintain intensity
*   Easy runs: Reduce duration by 25-30%
*   Strength training: Maintain 1 session at 70% volume
*   **Expected Outcomes:** Muscle damage markers drop 59%, fitness stable for 2 weeks

## 6. Cross-Training Load Equivalency
All activities converted to unified load metric using Session RPE × Duration, but also track running-specific volume separately:

**Deep Water Running:**
*   Time equivalency: 1:1 (60 min DWR = 60 min running in training effect)
*   Load calculation: Same RPE × duration
*   Running volume credit: 100% (fully maintains running-specific adaptations up to 6 weeks)

**Cycling:**
*   Time equivalency: 3:1 (90 min cycling ≈ 30 min running)
*   Load calculation: Same RPE × duration (internal load)
*   Running volume credit: 30-50% (partial running-specific transfer)

**Elliptical:**
*   Time equivalency: 2:1 (60 min elliptical ≈ 30 min running)
*   Load calculation: Same RPE × duration
*   Running volume credit: 50-70%

**Swimming:**
*   Time equivalency: 4:1 (80 min swimming ≈ 20 min running)
*   Load calculation: Same RPE × duration
*   Running volume credit: 20-30% (minimal running-specific transfer)

**Strength Training:**
*   No direct time equivalency to running
*   Load calculation: RPE × duration (heavy session might be 7-8 RPE × 45 min = 315-360 units)
*   Running volume credit: 0% (different stimulus)
*   Include in total load, separate from running volume

## 7. Visualization & User Communication

### 7.1. Performance Management Chart
*   X-axis: Time (weeks/months)
*   Y-axis: Training load (arbitrary units)
*   Three lines: Acute load (blue), Chronic load (orange), TSB (green/red area)
*   Background color zones indicating ACWR risk levels

### 7.2. ACWR Gauge
*   Semi-circular gauge (speedometer style)
*   Color-coded zones: Green (0.8-1.3), Yellow (0.5-0.8 and 1.3-1.5), Red (<0.5 and >1.5)
*   Current value with trend arrow (↑ ↓ →)
*   4-week trend sparkline

### 7.3. Load Distribution Breakdown
*   Pie chart or bar chart showing:
    *   Running volume
    *   Cross-training volume
    *   Strength training volume
*   Weekly and 4-week views

### 7.4. Alerts & Explanations
*   Plain-language explanations of any flags
*   "Your ACWR has been above 1.5 for 2 weeks, which research shows increases injury risk 4-fold. We're recommending a recovery week to bring this back into the safe zone."
*   Link to glossary for technical terms
*   Show research citations for educational transparency

## 8. Technical Implementation

### 8.1. Calculation Frequency
*   Daily: After any new activity logged or morning check-in completed
*   Real-time: When user logs session RPE
*   Batch: Nightly recalculation for all active athletes

### 8.2. Data Storage
*   Daily training load values (7+ years of history)
*   Weekly aggregates (ACWR, monotony, volume by type)
*   Monthly summaries for long-term trends

### 8.3. API Endpoints
*   `POST /activities/{id}/rpe` - Log session RPE
*   `GET /athlete/load-metrics` - Current ACWR, TSB, acute/chronic loads
*   `GET /athlete/load-history?weeks=16` - Historical load data
*   `GET /athlete/risk-alerts` - Current warnings and interventions

## 9. Success Metrics
*   **ACWR Compliance:** ≥90% of training weeks within 0.8-1.3 range
*   **Intervention Effectiveness:** When ACWR >1.5 flagged, injury occurrence within next 2 weeks <5%
*   **Injury Rate:** Overall training interruptions due to injury <10% of athletes per training cycle
*   **Recovery Week Adoption:** Athletes complete prescribed recovery weeks ≥85% of time
*   **Load Accuracy:** Session RPE collected within 30 minutes of workout end ≥80% of activities

## 10. Related PRDs
*   [00_OVERARCHING_VISION.md](./00_OVERARCHING_VISION.md) - Injury prevention philosophy
*   [06_ADAPTIVE_TRAINING_ENGINE.md](./06_ADAPTIVE_TRAINING_ENGINE.md) - Uses load metrics for daily decisions
*   [02_BACKEND_CORE.md](./02_BACKEND_CORE.md) - Computation engine
*   [01_MOBILE_CLIENT.md](./01_MOBILE_CLIENT.md) - Visualization and data collection
