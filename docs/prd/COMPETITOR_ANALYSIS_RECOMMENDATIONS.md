# Competitor Analysis & PRD Recommendations

Based on the review of `Competitor Research.md` and the existing PRD suite, the following additions and modifications are recommended to ensure RunningCoach is competitive with market leaders like Strava, Runna, and TrainAsONE.


## 2. Gamification & Retention
**Current State:** `01_MOBILE_CLIENT.md` mentions "Habit Streak" and "Competence Metrics".
**Competitor Insight:** Badges, Monthly Challenges, and "Levels" drive retention in consumer apps.
**Recommendation:**
*   **Update `01_MOBILE_CLIENT.md`:**
    *   **Badges System:** Awards for milestones (First 10K, 10-day streak, Early Bird).
    *   **Monthly Challenges:** "January Jumpstart (100km)", "Elevation Challenge".
    *   **Personal Records (PRs):** Auto-detect and celebrate PRs (1k, 5k, 10k, HM, M) within runs.

## 3. Onboarding & Personalization
**Current State:** `01_MOBILE_CLIENT.md` has a basic "Baseline Data Collection" section.
**Competitor Insight:** "Permission Priming" (Nike Run Club) and "Deep Onboarding" (TrainAsONE's assessment runs) are best practices.
**Recommendation:**
*   **Update `01_MOBILE_CLIENT.md`:**
    *   **Permission Priming:** Explicit UI flow explaining *why* Location/Health permissions are needed *before* the system dialog.
    *   **Assessment Protocol:** Add an "Initial Assessment Week" option in onboarding (3 runs to calibrate zones/fitness) instead of just relying on historical data.

## 4. Age-Appropriate Adaptation
**Current State:** `06_ADAPTIVE_TRAINING_ENGINE.md` mentions "Conservative Progression" but lacks specific age-based rules.
**Competitor Insight:** Runna is criticized for not handling masters athletes (40+) well. 3-week build cycles are better for 40+ than standard 4-week cycles.
**Recommendation:**
*   **Update `06_ADAPTIVE_TRAINING_ENGINE.md`:**
    *   **Explicit Rule:** If Age > 40 (configurable), default to **3-week cycle** (2 weeks build, 1 week recovery) vs. standard 4-week cycle.
    *   **Recovery Metrics:** Increase weight of "Soreness" and "Sleep" in readiness algorithm for older athletes.

## 5. Audio Guided Runs
**Current State:** `04_TRAINING_GUIDANCE.md` mentions "Audio & Haptic Cues" (stats only).
**Competitor Insight:** Nike Run Club's "Audio Guided Runs" (coaching + music + motivation) are a massive differentiator.
**Recommendation:**
*   **Update `04_TRAINING_GUIDANCE.md`:**
    *   **Coached Sessions:** Define a format for "Audio Experiences" - intro (purpose), middle (form cues, motivation), outro (summary).
    *   **Mindset Coaching:** Integrate "Mental Performance" audio clips during long runs.

## 6. Multi-Goal Support
**Current State:** PRDs imply a single "Goal Race".
**Competitor Insight:** TrainAsONE supports multiple concurrent goals (e.g., "Marathon in Oct" + "5K Tune-up in Aug").
**Recommendation:**
*   **Update `06_ADAPTIVE_TRAINING_ENGINE.md`:**
    *   **A/B/C Races:** Allow users to define "A Race" (Primary), "B Race" (Tune-up), "C Race" (Training Run).
    *   **Taper Logic:** Engine automatically schedules mini-tapers (3-4 days) for B-races without disrupting the macro-cycle for the A-race.

## 7. Mental Recovery Mode
**Current State:** `01_MOBILE_CLIENT.md` mentions "Rehab Mode" briefly.
**Competitor Insight:** Psychology predicts injury recovery better than physiology.
**Recommendation:**
*   **Update `09_CROSS_TRAINING_REHAB.md` & `01_MOBILE_CLIENT.md`:**
    *   **Identity Preservation:** Explicitly track "Fitness Retained" and "Rehab Consistency" to combat the "I'm not a runner anymore" depression.
    *   **Content:** "Mental Reps" (visualization exercises) assigned during injury downtime.

## Summary of Files to Update
1.  `docs/prd/01_MOBILE_CLIENT.md` (Social, Gamification, Onboarding)
2.  `docs/prd/04_TRAINING_GUIDANCE.md` (Audio Coaching)
3.  `docs/prd/06_ADAPTIVE_TRAINING_ENGINE.md` (Age Adaptation, Multi-goal)
4.  `docs/prd/09_CROSS_TRAINING_REHAB.md` (Mental Recovery)
5.  *New File:* `docs/prd/14_SOCIAL_COMMUNITY.md` (Optional, or fold into Mobile Client)
