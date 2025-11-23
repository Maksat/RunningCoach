# PRD: Overarching Vision & Architecture

## 1. Introduction
This document outlines the high-level vision, core philosophy, and architectural principles for the RunningCoach application. It serves as the root for all subsequent component PRDs, defining *why* we are building this and *how* it differs from existing solutions.

## 2. Vision Statement
RunningCoach is an **evidence-based, adaptive training companion** designed to guide runners through a minimum 16-20 week marathon training journey. Built on research showing that HRV-guided training improves performance by 6.2% versus 2.9% for fixed programs while eliminating non-responders entirely, RunningCoach dynamically adjusts to individual response patterns, life disruptions, and recovery status. It prioritizes **injury prevention through intelligent load management** and **long-term consistency** over rigid progression, using a "mild," non-intrusive coaching style that balances flexibility with the minimum effective training dose needed for marathon-specific adaptations.

## 3. Problem Statement
*   **Rigid Plans Fail:** Traditional static plans (PDFs, spreadsheets) cannot adapt to illness, work stress, or missed workouts, leading to "all-or-nothing" failure states. Research shows predetermined plans create 21% non-responders, while adaptive training eliminates them entirely.
*   **High Injury Rates:** Most runners get injured by doing too much, too soon. The traditional "10% rule" **lacks scientific support**—multiple studies show no injury prevention benefit from limiting weekly increases to 10%. The real issue is acute load spikes: acute-to-chronic workload ratios (ACWR) above 1.5 show **4-fold injury increases**.
*   **Disconnected Data:** Runners have data (watches, apps) but lack actionable *insight*. Knowing your HRV is low is useless without knowing *how* to adjust today's run. Moreover, most recovery metrics require overnight data that runners don't collect (watches aren't worn during sleep).

## 4. Core Value Propositions

### 4.1. Adaptive Training (The "Smart" Engine)
*   **Evidence-Based Dynamic Adjustments:** Research shows HRV-guided training produces 50% high responders versus 29% for predetermined plans. The plan adapts continuously—missed a long run (highest priority for marathon readiness)? The engine redistributes the load intelligently, following research-backed decision frameworks that prioritize workout hierarchy.
*   **Intelligent Load Management:** The engine accounts for *all* physical stress using **Session RPE × Duration** as the validated internal load metric. Unplanned activities (e.g., 3-hour bike ride, stressful day at work) are factored into acute load calculations, automatically adjusting subsequent training to preserve the safe ACWR window (0.8-1.3).
*   **Progressive Block Structure:** Training increases by 10-20% every 3-4 weeks (not weekly), respecting that bone remodeling requires 3-4 weeks to adapt—bone tissue needs this duration to respond to new mechanical stresses through increased mineralization and structural remodeling. Recovery weeks occur every 3-4 weeks with 20-25% volume reduction, including 40-50% cuts to long run distance—research shows muscle damage markers drop 59% during recovery weeks while fitness remains stable.
*   **Minimum Effective Training Dose:** Marathon readiness requires minimum 3 sessions weekly totaling 40+ km (25 miles), with longest run at minimum 13 miles (ideally 16-20 miles). Training below these thresholds compromises marathon-specific adaptations and race-day preparedness.
*   **Graduated Return-to-Sport Protocols:** Evidence-based 5-stage protocols for illness recovery (minimum 10 days rest, 7 days symptom-free before beginning) and injury rehabilitation, following the "neck check" rule and 2-3 days recovery per day of illness.
*   **Response-Based Progression:** Training stimulus adapts based on measured responses, not predetermined schedules. The system classifies responders (High/Moderate/Low) and adjusts training modality, volume, or intensity based on what works for each individual—no evidence supports "global non-responders."
*   **Individual Variable Importance:** After 8-12 weeks of monitoring, the system identifies each athlete's top 5 most predictive recovery markers. While group models show sleep quality and training load matter on average, individual response patterns differ substantially—some athletes respond primarily to HRV changes, others to sleep quality or mood. This personalization enables more accurate daily recommendations tailored to what actually predicts recovery for each individual.

### 4.2. Injury Prevention First
*   **Evidence-Based Load Management:** Research-proven ACWR monitoring maintains the "sweet spot" (0.8–1.3) where injury risk is lowest and adaptation optimal. The system flags ACWR above 1.5 for immediate intervention (4-fold injury risk increase) and tracks training monotony (mean/SD), with values exceeding 2.0 signaling dangerous training sameness.
*   **Integrated Strength & Prehab:** Strength training is periodized as a core component, not optional. **Nordic hamstring curls** alone reduce injuries by 51% (meta-analysis of 8,459 athletes). Combined heavy resistance (85-95% 1RM) plus plyometrics produces 4-8% running economy improvements and superior injury prevention. Sessions are strategically scheduled to minimize interference effects—research shows the 24-hour window exhibits reduced running economy and muscle activation following heavy strength work, with most acute interference effects dissipating by 48 hours. The system maintains minimum 48-hour spacing between heavy lower-body strength sessions and quality running workouts, while allowing strength after easy runs or on separate days during high-volume training periods.
*   **Practical Readiness Assessment:** Since most runners **don't wear watches during sleep**, the system prioritizes metrics that don't require overnight tracking:
    *   **Primary Metrics:** Morning subjective recovery rating (1-10 scale), session RPE collected 20-30 minutes post-workout, resting heart rate upon waking (can be measured manually or via brief check).
    *   **Enhanced Metrics (when available):** HRV measured upon waking (1-5 minutes), sleep quality self-rating × duration = sleep index, differential RPE (breathlessness vs. leg exertion).
    *   **Proxy Mechanisms:** HR-running speed index during warm-up (first 10 minutes), training efficiency trends (external load ÷ internal load), performance in standardized efforts.
*   **Training Efficiency Index Monitoring:** Tracks the ratio of external load (distance, pace) to internal load (RPE × duration) over 2-4 week windows. Upward trending efficiency indicates improving fitness—the same external work feels easier. Declining efficiency signals accumulating fatigue before performance drops become apparent, enabling proactive load adjustments.
*   **Traffic Light Decision System:** Multi-criteria daily readiness checks integrate 4-5 markers to determine Green (proceed as planned), Yellow (reduce intensity 5-10% OR volume 20%), or Red (easy running only or rest). This prevents single-metric overreaction while catching genuine fatigue patterns.

### 4.3. Holistic Approach
*   **Beyond Running:** Incorporates evidence-based nutrition protocols (10-12 g/kg carb loading for 36-48 hours pre-race, 60-90g/hour during marathon using dual-source carbs, periodized protein intake 1.2-2.0 g/kg), sleep quality assessment (even without wearables via subjective ratings), and mental readiness monitoring.
*   **Research-Backed Cross-Training:** Deep Water Running maintains marathon fitness for up to **6 weeks** without any land running (1:1 time equivalency). Cycling at 50% substitution maintains performance for 5 weeks (3:1 cycling:running ratio). Elliptical provides impact reduction with similar cardiovascular benefits (2:1 ratio). All cross-training is integrated into load calculations and ACWR monitoring.

## 5. Key Features

### 5.1. The "Brain" (Backend)
*   **Periodization Engine:** Manages macro-cycles (Base, Build, Peak, Taper) and micro-cycles.
*   **Load Calculator:** Uses **Session RPE × Duration** as the primary internal load metric.
*   **Alert System:** Detects dangerous trends (e.g., Monotony > 2.0, ACWR > 1.5) and prompts intervention.

### 5.2. The "Companion" (Client)
*   **Daily "Coach's Note":** A simple, human-readable summary of *why* today's workout is what it is (e.g., "We're keeping it easy today because your HRV is low.").
*   **Visual Feedback:** Simple visualizations of "Form" (TSB) and "Risk" (ACWR) without overwhelming technical jargon.
*   **Non-Intrusive:** Notifications are helpful nudges, not nagging.

### 5.3. Integration Ecosystem
*   **Wearable Agnostic:** Ingests data from Apple Health, Garmin, Fitbit, etc., to feed the backend models.
*   **Offline First:** Runners can view their plan and log workouts without internet; sync happens seamlessly in the background.

### 5.4. Training Interruption Management
*   **Detraining Timeline:** The system understands fitness loss follows predictable patterns:
    *   **0-2 weeks:** Plasma volume decreases causing early VO2max declines (4-7%), but muscular adaptations remain stable. Performance decline is reversible with proper resumption.
    *   **2-4 weeks:** VO2max declines 4-8% primarily from cardiovascular deconditioning. Endurance capacity decreases even when VO2max is maintained. Recovery requires approximately equivalent time off—a 3-week interruption needs roughly 3 weeks to fully restore fitness.
    *   **4+ weeks:** Declines accelerate and recovery may require 1.5-2× the interruption period. The system adjusts plan generation to account for these extended timelines.
*   **Minimum Maintenance Dose:** When full training is impossible (injury, extreme life demands), research identifies the minimum to maintain fitness: 1 high-intensity session weekly plus 50% normal easy volume maintains VO2max for 4+ weeks. The system can shift to "Maintenance Mode" during extended disruptions, preserving adaptations until normal training resumes.
*   **Maximum Cross-Training Substitution:** Deep Water Running can substitute all running for up to 6 weeks while maintaining marathon fitness. Cycling at 50% substitution maintains performance for 5 weeks. Beyond these periods, running-specific neuromuscular patterns decline despite preserved cardiovascular fitness, requiring graduated return-to-running protocols.

## 6. Core Architectural Principles
*   **Thin Client:** The mobile app is a display and input surface. It does not calculate training loads or generate plans. This ensures consistency and allows the "Brain" to evolve without app updates.
*   **Heavy Backend:** All complex logic (analytics, plan generation, adaptation algorithms) resides on the server.
*   **Offline First / Seamless Sync:** The app must be fully functional offline. Data consistency is managed via a robust sync infrastructure (see `05_SYNC_INFRASTRUCTURE.md`).
*   **Context Over Complexity:** While algorithms provide data-driven recommendations, the system provides override capability for human judgment during unusual circumstances (major life stress, illness nuances, personal preferences). No algorithm replaces contextual understanding when athletes face situations outside normal training parameters. Educated athletes equipped with clear explanations make better decisions than rigid automation.
*   **Continuous Model Refinement:** Prediction accuracy is tracked continuously by comparing forecasted outcomes (recovery predictions, performance estimates) against actual reported results. Decision thresholds and model parameters adjust based on real-world outcomes rather than purely theoretical models. This feedback loop ensures the system improves over time and adapts to emerging patterns in the user population.

## 7. Success Metrics
*   **Injury Prevention:** Primary success metric—minimize training interruptions due to injury. Target: Keep ACWR within 0.8-1.3 for 90%+ of training weeks, with immediate intervention when ratios exceed 1.5 for 2+ consecutive weeks.
*   **Adaptive Effectiveness:** % of non-responders to training stimulus (target: <5%, compared to 21% for predetermined plans). Track individual response patterns and modality-specific adaptations.
*   **Adherence Quality:** % of completed planned sessions adjusted for intelligent adaptations (e.g., converting failed workout to easy run counts as adherence if system recommended it).
*   **Performance Progression:** Measurable improvement in validated metrics:
    *   **Running Economy:** Track HR-pace relationship at standardized efforts (research shows 4-8% improvements possible from strength and plyometric integration).
    *   **Lactate Threshold Pace** improvement over 12-16 week build phase.
    *   **Training Efficiency Index:** External load (distance/pace) ÷ Internal load (RPE × duration) trending positive.
*   **Prediction Accuracy:** Race time prediction within 2% variance using performance trends and training load modeling (target aligned with research-validated forecasting methods).
*   **Recovery Prediction:** Accuracy of next-day recovery predictions compared to actual reported recovery (enables model refinement using LASSO regression on top 5 individual variables).
*   **Model Refinement Effectiveness:** Track continuous improvement by comparing prediction accuracy before and after threshold adjustments. System should demonstrate increasing accuracy over time as it learns from real-world outcomes versus theoretical models. Target: 10-15% improvement in recovery prediction accuracy within first 6 months of operation.
*   **Variable Importance Identification:** Successfully identify individual top 5 predictive markers within 8-12 weeks of monitoring for each athlete. Target: 80%+ of users receive personalized variable importance rankings by week 12, enabling truly individualized recommendations.

## 8. Related PRDs
*   [01_MOBILE_CLIENT.md](./01_MOBILE_CLIENT.md) - UI/UX and offline capabilities.
*   [02_BACKEND_CORE.md](./02_BACKEND_CORE.md) - The algorithms, database, and API.
*   [03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md) - Data ingestion and normalization.
*   [04_TRAINING_GUIDANCE.md](./04_TRAINING_GUIDANCE.md) - Specific workout types and coaching content.
*   [05_SYNC_INFRASTRUCTURE.md](./05_SYNC_INFRASTRUCTURE.md) - Data synchronization and conflict resolution.
*   [06_ADAPTIVE_TRAINING_ENGINE.md](./06_ADAPTIVE_TRAINING_ENGINE.md) - Logic for daily plan adjustments.
*   [07_LOAD_MANAGEMENT.md](./07_LOAD_MANAGEMENT.md) - ACWR and injury prevention metrics.
*   [08_STRENGTH_PLYOMETRICS.md](./08_STRENGTH_PLYOMETRICS.md) - Integrated strength protocols.
*   [09_CROSS_TRAINING_REHAB.md](./09_CROSS_TRAINING_REHAB.md) - Equivalency and rehab protocols.
*   [10_NUTRITION_FUELING.md](./10_NUTRITION_FUELING.md) - Daily and race-day nutrition strategies.
