# PRD: Wearable Integration (Garmin Focus)

## 1. Introduction
This document outlines the product requirements for the RunningCoach wearable experience. The wearable app serves as the **primary interface during training**, acting as a "Coach on the Wrist." It is not merely a data logger; it is an active guidance system that ensures athletes adhere to the prescribed training plan, specifically managing intensity and duration in real-time.

## 2. Strategic Focus & Supported Devices
For the initial release, we will focus **exclusively on the Garmin ecosystem**, leveraging its dominance in the serious running market and the robust capabilities of the Connect IQ (CIQ) platform.

### 2.1. Primary Platform (Phase 1)
*   **Garmin (Connect IQ):** A dedicated Device App (not just a Data Field) to allow full control over the UI, bi-directional communication, and custom sensor handling.
*   **Target Devices:** Must support MIP (Memory in Pixel) and AMOLED displays (Forerunner 245/255/265/945/955/965, Fenix 6/7/8, Epix, Venu 2/3).

### 2.2. Future Scope (Phase 2+)
*   Apple Watch (watchOS)
*   Wear OS (Samsung, Pixel Watch)
*   Coros & Suunto (API integration)

## 3. Core User Experience Principles
1.  **Glanceability:** Runners moving at speed cannot read small text. UI must rely on **color**, **position**, and **large typography**.
2.  **Actionable Feedback:** Don't just show "HR: 165". Show "HR: 165 (High) -> Slow Down".
3.  **Offline Independence:** The watch must be able to guide a full workout (Run or Strength) without the phone present.
4.  **Frictionless Sync:** Workouts sync to the watch automatically; completed data syncs back immediately upon reconnection.

## 4. Data Collection & Synchronization

### 4.1. Real-Time Data Collection
The app must collect high-fidelity data at **1Hz (1 sample per second)** to ensure accurate load calculation and biomechanical analysis.

*   **Core Metrics:**
    *   **Heart Rate:** 1Hz (Internal optical or external strap via ANT+/BLE).
    *   **GPS:** 1Hz (Lat/Lon, Altitude, Speed, Heading).
    *   **Cadence:** Steps per minute.
    *   **Power:** Running Power (if supported by device/accessory).
    *   **R-R Intervals:** For HRV analysis (if hardware supports).
*   **Strength/Plyo Metrics:**
    *   **Accelerometer:** Raw 3-axis acceleration (for jump count/height estimation in plyometrics - *feasibility to be validated*).
    *   **Rep Counting:** Auto-detection of reps (leveraging Garmin's native algorithms if accessible, or manual input).

### 4.2. Synchronization Modes
The system must handle two distinct scenarios seamlessly.

#### Mode A: Connected (Phone Present)
*   **Scenario:** Athlete runs with phone in pocket/belt.
*   **Behavior:**
    *   **Live Bridge:** Watch sends real-time telemetry (HR, Pace, Location) to the Phone App via Bluetooth Low Energy (BLE).
    *   **Audio Cues:** Phone generates high-quality audio cues (Text-to-Speech) based on watch triggers.
    *   **Instant Upload:** Workout is uploaded to the cloud via the Phone's internet connection immediately upon finish.

#### Mode B: Standalone (No Phone)
*   **Scenario:** Athlete leaves phone at home.
*   **Behavior:**
    *   **Local Storage:** Workout data is recorded to a local `.fit` file on the watch storage.
    *   **On-Device Feedback:** Watch provides all necessary alerts via Vibration and Tone (Beeps).
    *   **Store & Forward:** Upon returning within range of the phone, the Connect IQ app initiates a sync via the Garmin Connect Mobile (GCM) SDK to transfer the `.fit` file to the Phone App, which then uploads to the Cloud.

## 5. Detailed Screen Definitions

### 5.1. Running Screens

#### Screen 1: Pre-Run (Context & Readiness)
*   **Goal:** Confirm GPS lock, sensor connection, and workout selection.
*   **UI Elements:**
    *   **Header:** "Today: [Workout Name]" (e.g., "Tempo Run")
    *   **Status Indicators:** GPS (Red/Green), HR (Icon), Phone (Icon).
    *   **Action:** Large "START" prompt.
    *   **Readiness:** "Condition: Green" (Synced from backend).

#### Screen 2: Active Run (The Dashboard)
*   **Layout:** 3-Field Grid (Customizable, but defaults to):
    *   **Top (Primary - Large):** **Pace** (or Power). Background color indicates adherence (Green=Good, Red=Fast, Blue=Slow).
    *   **Middle (Intensity - Bar):** **Heart Rate** + Zone Gauge.
    *   **Bottom (Context):** **Lap Distance** / **Time Remaining**.
*   **Alerts:** Full-screen overlay + Vibe/Tone for "Zone Exit" or "Interval Change".

#### Screen 3: Interval Guidance
*   **Trigger:** Appears 5s before interval change.
*   **UI:**
    *   **Big Text:** "GO!" or "REST"
    *   **Target:** "Target: 4:15/km"
    *   **Countdown:** "Time: 3:00"
*   **Interaction:** Lap button skips to next step.

#### Screen 4: Post-Run RPE (Mandatory)
*   **Trigger:** Immediately after stopping and saving.
*   **UI:** Vertical list or Arc Slider.
    *   "How hard was that?"
    *   Selection: 1 (Easy) to 10 (Max).
    *   **Constraint:** Cannot exit until selected.

### 5.2. Strength & Plyometrics Screens
*New section specifically for the Strength PRD requirements.*

#### Screen 1: Exercise View
*   **Goal:** Guide the user through the current set.
*   **UI Elements:**
    *   **Header:** Exercise Name (e.g., "Nordic Curls").
    *   **Central:** **Reps Target** (e.g., "5 Reps").
    *   **Footer:** Weight/Resistance (e.g., "Bodyweight" or "20kg").
*   **Interaction:** Press "Lap" button to complete set.

#### Screen 2: Rest Timer
*   **Trigger:** Auto-starts after completing a set.
*   **UI Elements:**
    *   **Countdown:** Large timer (e.g., "1:30").
    *   **Next Up:** Preview of next exercise.
    *   **Skip:** Button to skip rest if ready.

#### Screen 3: Plyometric Counter (Experimental)
*   **Goal:** Track contacts/jumps.
*   **UI Elements:**
    *   **Counter:** "Jumps: 12/20".
    *   **Feedback:** "Higher!" (if accelerometer detects low flight time - *future feature*).
*   **Fallback:** Manual input of reps completed if auto-detection fails.

## 6. Technical Architecture (Garmin Connect IQ)

### 6.1. App Structure
*   **Type:** Device App (allows full UI control).
*   **Language:** Monkey C.
*   **SDK:** Connect IQ 4.x (System 5 preferred).

### 6.2. Data Flow
1.  **Plan Ingestion:**
    *   Phone App fetches JSON plan from Backend.
    *   Phone App sends JSON payload to Watch App via GCM (Communications Module).
    *   Watch App persists plan to `Storage`.
2.  **Execution:**
    *   Watch App runs the session, recording to `ActivityRecording` session.
    *   Custom fields (RPE, Plyo Counts) added as `DeveloperFields` to the `.fit` file.
3.  **Upload:**
    *   **Scenario A (GCM):** Watch passes `.fit` file to GCM -> Garmin Cloud -> Webhook -> Our Backend.
    *   **Scenario B (Direct):** Watch passes payload to Phone App via GCM `transmit` -> Phone App -> Our Backend (Preferred for immediate feedback, but Scenario A is the robust fallback).

## 7. Success Metrics
*   **Reliability:** < 0.1% crash rate on supported devices.
*   **Sync Speed:** "No Phone" runs sync within 60 seconds of phone reconnection.
*   **Data Quality:** < 1% of runs missing HR or GPS data (excluding indoor mode).
*   **Adherence:** > 90% of Strength sessions have sets/reps confirmed via watch.
