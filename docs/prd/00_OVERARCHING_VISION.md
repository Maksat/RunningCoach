# PRD: Overarching Vision & Architecture

## 1. Introduction
This document outlines the high-level vision, core philosophy, and architectural principles for the RunningCoach application. It serves as the root for all subsequent component PRDs, defining *why* we are building this and *how* it differs from existing solutions.

## 2. Vision Statement
RunningCoach is a **holistic, intelligent, and trusted private coach** dedicated to one singular goal: **maximizing the runner's chance of achieving their personal best** in a long-distance race.

Unlike social platforms or generic trackers, RunningCoach acts as a silent, observant expert who understands the runner's physiology deeply. It respects life events—travel, sickness, stress—and adapts the plan dynamically. It assesses the readiness of every body system (respiratory, muscular, neural, skeletal) to provide **precise, daily guidance**. It is not a cheerleader; it is a strategist that ensures the runner arrives at the start line healthy, fueled, and peaked.

## 3. Problem Statement
*   **Generic Plans Fail Life:** Static plans break when life happens (sickness, travel, work stress). This leads to guilt, injury, or quitting.
*   **Injury Derails Dreams:** Most runners fail not because of lack of effort, but because of "too much, too soon." Ignoring the readiness of tendons or bones leads to setbacks.
*   **Fragmented Advice:** Runners juggle strength apps, nutrition guides, and running plans. There is no single "brain" connecting these dots.
*   **Social Noise:** Comparison is the thief of joy. Strava and social feeds create pressure to run too fast or too far, sabotaging specific training adaptations.

## 4. Core Value Propositions

### 4.1. The "Holistic Coach" (Multi-System Readiness)
The app treats the runner as a complex biological system, not just a pair of lungs. It assesses readiness across four key dimensions using smart watch data and performance metrics:
1.  **Cardio-Respiratory:** (HRV, Resting HR) Is the engine ready?
2.  **Muscular:** (Soreness, recent volume) Are the legs repaired?
3.  **Skeletal/Connective:** (Acute/Chronic Load, Surface impact) Are bones and tendons at risk?
4.  **Neural/CNS:** (Sleep quality, Stress) Is the nervous system fried?

**The Promise:** "We will never ask you to run if your body isn't ready. We will push you when it is."

### 4.2. Intelligent Adaptability
*   **Life-Aware:** The plan is fluid. If you are sick, it switches to a "Return to Health" protocol. If you travel, it suggests maintenance workouts.
*   **Dynamic Periodization:** Missed a long run? The engine doesn't just "skip" it; it reshuffles the week to preserve the key stimulus or moves it to a future block.
*   **Minimum Effective Dose:** We prioritize the *least* amount of training needed to achieve the goal, minimizing wear and tear.

### 4.3. Injury Prevention as a Strategy
*   **Integrated Prehab:** Strength and balance exercises are not optional add-ons; they are prescribed with the same weight as running miles.
*   **Load Management:** We monitor Acute-to-Chronic Workload Ratios (ACWR) to keep the runner in the "Safe Zone" (0.8-1.3).
*   **Traffic Light System:** Daily readiness is simple: Green (Go), Yellow (Modify), Red (Rest).

### 4.4. Complete Trust
*   **No Social Distractions:** No leaderboards, no kudos, no feed. This is a private relationship between the runner and the coach.
*   **Scientific Fueling:** Nutrition is tracked and prescribed to ensure the engine has fuel.
*   **Transparent Logic:** The coach explains *why*: "We cut this run short because your CNS fatigue is high."

## 5. Key Features

### 5.1. The "Brain" (Backend)
*   **Multi-System Analysis Engine:** Ingests sleep, HRV, stress, and workout data to output a 4-dimensional readiness score.
*   **Adaptive Scheduler:** Re-plans the entire season instantly when a disruption occurs.

### 5.2. The "Companion" (Client)
*   **Clean, Focused UI:** No clutter. Just the daily directive and the "Why".
*   **Body System Scan:** A visual representation of the runner's body showing the status of each system (e.g., Bones: 🟢, Muscles: 🟡).
*   **Nudges:** Intelligent, timely notifications (e.g., "Go to bed early tonight, your CNS is stressed").

### 5.3. Integration Ecosystem
*   **Wearable Centric:** Relies heavily on passive data (Garmin/Apple Health) for physiological inputs.
*   **Offline First:** The coach is always with you, even without signal.

## 6. Core Architectural Principles
*   **Privacy First:** Data is for the user's benefit, not for sharing.
*   **Thin Client:** The app is a window into the "Brain".
*   **Reliability:** Offline capabilities ensure the plan is always accessible.

## 7. Success Metrics
*   **Plan Completion Rate:** % of users who reach the start line of their goal race.
*   **Injury Rate:** % of users reporting injuries (Target: <10%).
*   **Personal Bests:** % of users achieving their goal time.
*   **Trust Score:** User rating of "Do you trust the coach's decisions?"

## 8. Related PRDs
*   [01_MOBILE_CLIENT.md](./01_MOBILE_CLIENT.md) - UI/UX focused on clarity and readiness.
*   [02_BACKEND_CORE.md](./02_BACKEND_CORE.md) - The logic behind the multi-system analysis.
*   [03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md) - Data ingestion.
*   [04_TRAINING_GUIDANCE.md](./04_TRAINING_GUIDANCE.md) - Workout types and adaptability.
*   [06_ADAPTIVE_TRAINING_ENGINE.md](./06_ADAPTIVE_TRAINING_ENGINE.md) - The scheduling algorithms.
*   [07_LOAD_MANAGEMENT.md](./07_LOAD_MANAGEMENT.md) - Injury prevention metrics.
*   [10_NUTRITION_FUELING.md](./10_NUTRITION_FUELING.md) - Fueling the engine.
