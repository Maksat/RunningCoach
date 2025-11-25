# PRD: Adaptive Training Engine & Guidance

## 1. Introduction
This document defines the "Brain" of RunningCoach. Unlike static plans, the Adaptive Engine continuously analyzes the athlete's **Body State** across four distinct systems (Cardio, Muscular, Skeletal, CNS) to prescribe the optimal daily dose of training.

## 2. The 4-System Analysis Engine

### 2.1. Concept
We do not use a single "Readiness Score." A runner might have great HRV (Cardio Green) but sore calves (Muscular Yellow). The engine treats these systems independently.

### 2.2. System Definitions & Inputs

#### **1. Cardio-Respiratory System**
*   **Role:** The Engine. Delivers oxygen.
*   **Inputs:**
    *   **HRV (rMSSD):** vs 30-day baseline.
    *   **Resting HR:** vs 30-day baseline.
    *   **Cardiac Drift:** HR decoupling in previous run.
*   **Logic:**
    *   **Green:** HRV within baseline.
    *   **Yellow:** HRV < baseline - 1SD.
    *   **Red:** HRV < baseline - 2SD OR RHR > baseline + 5bpm.

#### **2. Muscular System**
*   **Role:** The Movers. Muscles and tendons.
*   **Inputs:**
    *   **Subjective Soreness:** 1-10 scale (Morning Check-in).
    *   **Volume Fatigue:** 7-day volume vs 4-week avg.
*   **Logic:**
    *   **Green:** Soreness < 3.
    *   **Yellow:** Soreness 4-6 OR Volume > 120% baseline.
    *   **Red:** Soreness > 7 (Potential Injury).

#### **3. Skeletal System**
*   **Role:** The Structure. Bones and joints.
*   **Inputs:**
    *   **ACWR (Acute:Chronic Workload Ratio):** Load management.
    *   **Impact Load:** Ground reaction forces (if available).
*   **Logic:**
    *   **Green:** ACWR 0.8 - 1.3.
    *   **Yellow:** ACWR 1.3 - 1.5.
    *   **Red:** ACWR > 1.5 (High Injury Risk).

#### **4. CNS (Central Nervous System)**
*   **Role:** The Driver. Neural drive and motivation.
*   **Inputs:**
    *   **Sleep:** Duration + Quality.
    *   **Mental Stress:** Subjective 1-10.
    *   **Motivation:** Subjective 1-10.
*   **Logic:**
    *   **Green:** Sleep > 7h, Stress < 5.
    *   **Yellow:** Sleep < 6h, Stress 6-7.
    *   **Red:** Sleep < 5h, Stress > 8.

## 3. Adaptation Logic (The "Prescription")

### 3.1. Synthesis Matrix
The engine combines the 4 system states to determine the daily prescription.

| Scenario | System State | Prescription Adjustment | Coach's Note |
| :--- | :--- | :--- | :--- |
| **All Clear** | All Green | **Execute Plan** | "All systems go. Nail the workout." |
| **Engine Trouble** | Cardio Yellow | **Reduce Intensity** (Keep Volume) | "Heart is tired. Run the miles, but keep HR in Zone 1." |
| **Legs Heavy** | Muscular Yellow | **Reduce Volume** (Keep Intensity) | "Legs need a break. Shorten the run, but keep the strides." |
| **Bone Risk** | Skeletal Yellow | **Cross-Train / Soft Surface** | "High impact load detected. Swap run for bike or swim." |
| **Brain Fog** | CNS Yellow | **Remove Complexity** | "Stress is high. Just run easy, no intervals today." |
| **Red Light** | Any System Red | **Rest / Active Recovery** | "Red flag detected. We are prioritizing recovery today." |

### 3.2. Life Event Protocols

#### **"I'm Sick" Protocol**
*   **Trigger:** User reports "Sick" in check-in.
*   **Action:**
    *   **Day 1-3:** Clear schedule. Assign "Rest".
    *   **Day 4:** Prompt "How do you feel?".
    *   **Return:** If "Good", insert "Return to Run" (20m walk/jog). If "Bad", extend Rest.

#### **"I'm Traveling" Protocol**
*   **Trigger:** User reports "Travel" for specific dates.
*   **Action:**
    *   Replace Long Runs with "Maintenance Intervals" (30-45m).
    *   Replace Gym Strength with "Hotel Room Mobility".
    *   **Goal:** Maintain habit, sacrifice volume.

## 4. Progression & Periodization

### 4.1. The Macro-Cycle
*   **Base (Weeks 1-8):** Focus on Skeletal/Muscular durability. Low intensity, increasing volume.
*   **Build (Weeks 9-16):** Focus on Cardio/Muscular power. Intervals and Tempos introduced.
*   **Peak (Weeks 17-20):** Max specificity. Long runs with marathon pace.
*   **Taper (Weeks 21-23):** Shed fatigue (CNS/Muscular) while maintaining Cardio engine.

### 4.2. The "Missed Workout" Logic
*   **Rule:** **Never Catch Up.**
*   **Logic:**
    *   If missed Easy Run: Delete.
    *   If missed Key Workout: Move to next slot *only if* it doesn't create back-to-back hard days. Otherwise, delete.
    *   **Priority:** Long Run > Tempo > Intervals > Easy.

## 5. Success Metrics
*   **Injury Rate:** < 5% of users reporting injury.
*   **Plan Completion:** > 85% of *modified* sessions completed.
*   **Personal Bests:** Users achieving goal time.
