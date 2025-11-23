# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RunningCoach is an evidence-based, adaptive marathon training application in early development (pre-alpha). It prioritizes injury prevention through intelligent load management while maintaining optimal training stimulus through personalized adaptation.

**Core Philosophy:**
- Injury prevention first using ACWR (Acute-to-Chronic Workload Ratio) monitoring (0.8-1.3 sweet spot)
- Evidence-based periodization with HRV-guided training showing 6.2% performance improvement vs 2.9% for fixed programs
- Dynamic adaptation using multi-metric monitoring (HRV, subjective recovery, sleep, training load)
- Holistic integration of running, strength training, drills, cross-training, and nutrition

**Project Status:** No code implementation yet - currently in PRD/design phase with comprehensive documentation.

## Architecture & Design

The application follows a **thin client, heavy backend** architecture:

### Mobile Client (iOS/Android)
- Display and input surface only
- Offline-first with seamless background sync
- Does NOT calculate training loads or generate plans
- Bottom navigation: Today | Plan | Progress | Library | You

### Backend Core
- Service-Oriented Architecture (SOA) or Modular Monolith
- **API Gateway:** Stateless, handles HTTP from client and webhooks
- **Asynchronous Worker Cluster:** Background jobs (data normalization, metric calculations, plan generation)
- **Primary Database:** PostgreSQL for structured user data, plans, activities
- **Time-Series Store:** Optional (TimescaleDB/InfluxDB) for high-frequency HR/GPS data
- **Job Queue:** Redis-backed (Sidekiq/BullMQ/Celery)
- **Cache Layer:** Redis for computed metrics

### Core Components

**Training Engine:**
- Periodization algorithms (Base → Build → Peak → Taper phases)
- Load calculation using Session RPE × Duration as primary internal load metric
- Decision trees for workout modification
- ACWR calculation: Acute Load (7-day EWMA) / Chronic Load (28-day EWMA)
- Training Stress Balance (TSB) = Chronic - Acute

**Monitoring System:**
- Multi-metric data collection (HRV, subjective recovery, sleep, training load)
- Traffic light readiness system (Green/Yellow/Red)
- Baseline establishment using 7-day rolling averages
- Alert system for dangerous patterns (Monotony > 2.0, ACWR > 1.5)

**Adaptation Logic:**
- Graduated progression/reduction protocols
- Performance-based adjustments
- Illness/injury return-to-training protocols (5-stage graduated)
- Responder classification (High/Moderate/Low)

**Integration Layer:**
- Wearable device APIs (Garmin, Polar, Apple Watch)
- Fitness platform connections
- Nutrition tracking

## Key Entities & Data Schema

**User:** Identity, profile (weight, gender, DOB), baselines (resting HR, HRV, max HR, LT HR), responder status

**Activity (Workout):** Timestamp, source, duration, distance, HR metrics, RPE, calculated internal load (RPE × Duration)

**DailyMetric:** Date, resting HR, HRV, sleep (duration × quality = sleep index), subjective scores (readiness, soreness, stress, mood), calculated readiness score

**TrainingPlan:** Goal race date/distance, phases structure (Base/Build/Peak/Taper), version tracking

**ScheduledWorkout:** Plan link, date, type, target metrics, status (Planned/Completed/Skipped/Missed), completed activity link

**RollingStats:** Acute load (7-day EWMA), chronic load (28-day EWMA), ACWR, TSB, training monotony

## Critical Training Logic

### Load Management Thresholds
- **ACWR Sweet Spot:** 0.8-1.3 (optimal adaptation, lowest injury risk)
- **ACWR Caution:** 1.3-1.5 (moderate risk)
- **ACWR Danger:** >1.5 (4-fold injury increase, immediate intervention required)
- **Training Monotony:** >2.0 (dangerous sameness, requires variation)
- **TSB:** Positive = freshness, negative = fatigue, <-30 demands intervention

### Traffic Light System
**Green (proceed as planned):** All markers within normal range, HRV normal, recovery >5/7, previous workout completed successfully

**Yellow (modify workout):** 1-2 markers outside range, reduce intensity 5-10% OR volume 20%

**Red (recovery day):** 3+ markers outside range, easy running only or complete rest

### Progression Guidelines
- Increase load by 10-20% every 3-4 weeks (NOT weekly - bone remodeling requires 3-4 weeks)
- Recovery weeks every 3-4 weeks with 20-25% volume reduction
- Intensity distribution: 80% easy (Zone 1), 20% hard (polarized training)
- Minimum 48 hours between quality sessions

### Illness/Injury Protocols
- "Neck check" rule: symptoms above neck may allow easy training, below neck demands rest
- 5-stage graduated return: minimum 10 days rest, 7 days symptom-free before beginning
- General guideline: 2-3 days recovery per day of illness

### Strength Training Periodization
- **Base (8-12 weeks):** 2-3 sessions/week, 60-75% 1RM, 3-4 sets of 8-12 reps
- **Build (6-8 weeks):** 2 sessions/week, 80-90% 1RM, 3-5 sets of 4-6 reps, add plyometrics
- **Peak (6-8 weeks):** 1-2 sessions/week, 70-85% 1RM, 2-3 sets of 4-6 reps, maintain adaptations
- **Taper (2-3 weeks):** Max 1 light session, nothing final week

Key exercises: Nordic hamstring curls (51% injury reduction), single-leg work, hip strengthening, heavy compound lifts (squats, deadlifts at 85-95% 1RM)

### Cross-Training Equivalency
- **Deep Water Running:** 1:1 time ratio (gold standard, maintains fitness 6 weeks)
- **Cycling:** 3:1 ratio (30km bike ≈ 10km run)
- **Elliptical:** 2:1 ratio
- **Swimming:** 4:1 ratio (1500m swim ≈ 6km run)

### Nutrition Targets
- **Daily Carbs:** 5-7 g/kg (moderate training) to 8-12 g/kg (peak weeks)
- **Daily Protein:** 1.2-2.0 g/kg during intense training
- **Race Week Loading:** 10-12 g/kg for 36-48 hours pre-race
- **During Marathon:** 60-90g carbs/hour using dual-source (glucose + fructose 2:1)

## Machine Learning Roadmap

**Phase 1 (Weeks 1-4):** Session RPE collection, basic load calculation, visualization

**Phase 2 (Weeks 5-8):** TSB analytics, sleep tracking, alert systems

**Phase 3 (Weeks 9-16):** Decision tree implementation, HRV integration, recommendation engine

**Phase 4 (Weeks 17-24):** LASSO regression for recovery prediction, individual response profiling

**Phase 5 (Ongoing):** Advanced personalization, modality-specific recommendations, continuous refinement

## Technology Recommendations

**Backend:** Python (Django/FastAPI) preferred for data science/ML libraries (Pandas, Scikit-learn)

**Database:** PostgreSQL (JSONB support, time-series extensions)

**Queue:** Redis + Celery (Python) or BullMQ (Node)

**Mobile:** Platform TBD (likely React Native or native iOS/Android)

**Hosting:** Containerized (Docker) on AWS/GCP

## Development Priorities

1. **Start Backend-First:** Core training engine and load calculations are the differentiator
2. **Implement Safety First:** ACWR monitoring and traffic light system prevent injury
3. **Build for Offline:** Sync infrastructure is critical - athletes train without connectivity
4. **Session RPE is King:** Simplest validated internal load metric, requires post-workout collection
5. **Baseline Before Adaptation:** Need 2-4 weeks data before making training adjustments
6. **Focus on 5-7 Key Metrics:** Don't overwhelm users with 15+ daily questions

## Critical Design Principles

- **Thin Client:** Mobile app displays and collects input only, never calculates training
- **Heavy Backend:** All complex logic on server for consistency and evolution
- **Offline First:** Full functionality without internet, background sync when available
- **Safety Over Performance:** Injury prevention takes precedence over aggressive progression
- **Evidence-Based:** Every recommendation backed by research (see Initial research.md)
- **"Mild" Coaching Style:** Non-intrusive, educational, balances flexibility with structure

## Related Documentation

- `/docs/prd/00_OVERARCHING_VISION.md` - Core philosophy and value propositions
- `/docs/prd/01_MOBILE_CLIENT.md` - UX/UI specifications, interaction flows
- `/docs/prd/02_BACKEND_CORE.md` - Architecture, API specs, processing pipelines
- `/docs/prd/03_WEARABLE_INTEGRATION.md` - Device integration specifications
- `/docs/prd/04_TRAINING_GUIDANCE.md` - Workout types and coaching content
- `/docs/prd/05_SYNC_INFRASTRUCTURE.md` - Offline-first synchronization
- `/docs/prd/06_ADAPTIVE_TRAINING_ENGINE.md` - Daily adjustment logic
- `/docs/prd/07_LOAD_MANAGEMENT.md` - ACWR and injury prevention
- `/docs/prd/08_STRENGTH_PLYOMETRICS.md` - Integrated strength protocols
- `/docs/prd/09_CROSS_TRAINING_REHAB.md` - Equivalency and rehab protocols
- `/docs/prd/10_NUTRITION_FUELING.md` - Daily and race-day nutrition
- `/Initial research.md` - 360+ page comprehensive research synthesis (ALL training logic is derived from this)

## Security & Compliance

- Treat all health data (HR, weight, sleep) as sensitive
- Encrypt at rest (DB volume encryption) and in transit (TLS 1.3)
- Support GDPR: data export and account deletion
- Anonymize data for aggregate ML training
- Ensure webhook idempotency (wearables retry on failure)
