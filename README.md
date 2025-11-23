# Marathon Training Platform

An evidence-based, adaptive marathon training application that prioritizes injury prevention while maintaining optimal training stimulus through intelligent load management and personalized adaptation.

## Overview

This application addresses a critical gap in existing marathon training tools: the inability to dynamically adapt training plans when life interferes or when individual response to training varies. While platforms like Garmin Coach offer adaptive features, they lack flexibility for rescheduling workouts due to illness, travel, or poor weather. Generic training plans ignore individual recovery patterns and load tolerance, leading to either injury or undertraining.

Our solution implements scientifically-validated training periodization with multi-metric monitoring systems that balance structured progression with intelligent adaptation. Research demonstrates that individualized, HRV-guided training produces 6.2% performance improvement versus 2.9% for fixed programs, while reducing non-responders from 21% to zero.

## Core Principles

**Injury Prevention First**: Training load management using acute-to-chronic workload ratios (ACWR) between 0.8-1.3, with automatic intervention when ratios exceed safe thresholds that show 4-fold injury increases.

**Evidence-Based Periodization**: 16-20 week marathon preparation structured through base building, build, peak, and taper phases following intensity distribution patterns (80% easy, 20% hard) proven effective in elite athlete studies.

**Adaptive Intelligence**: Multi-criteria decision algorithms that modify training based on HRV, subjective recovery scores, performance trends, sleep quality, and training load patterns—maintaining periodization structure while adjusting tactical execution.

**Holistic Integration**: Comprehensive approach combining running workouts, strength training protocols (heavy resistance + plyometrics for 4-8% running economy improvements), running drills, cross-training guidelines, and nutrition strategies throughout the training cycle.

## Key Features

### Dynamic Training Adaptation
- Real-time workout modification based on daily readiness markers
- Intelligent rescheduling that maintains weekly structure while accommodating life disruptions
- Graduated return-to-training protocols after illness (5-stage progression with minimum 10-day recovery)
- Performance-based adjustments when workouts fail or exceed expectations

### Load Management & Monitoring
- Acute-to-chronic workload ratio calculation and visualization
- Training Stress Balance (TSB) tracking showing fitness, fatigue, and form
- Training monotony detection preventing dangerous training sameness
- Multi-metric traffic light system (green/yellow/red) for daily training decisions

### HRV-Guided Training
- Integration with overnight HRV data from wearable devices
- Individual baseline establishment using 7-day rolling averages
- Automated intensity/volume adjustments based on HRV trends
- Support for both overnight measurements and morning chest-strap protocols

### Comprehensive Strength Training
- Phase-specific strength periodization (anatomical adaptation → maximal strength → power maintenance)
- Evidence-based exercise library including Nordic hamstring curls (51% hamstring injury reduction), single-leg work, hip strengthening, and core stability
- Progressive plyometric protocols (120-200 jumps per session building to 4-7% running economy improvements)
- Interference effect management through strategic scheduling

### Running Drills & Technique
- Progressive drill integration (high knees, A-skips, B-skips, bounding)
- Plyometric hopping protocols (5 minutes daily improving economy 4-7%)
- Phase-appropriate volume (2 sessions weekly base phase → 1 session weekly peak phase)
- Drill-to-stride progressions for race preparation

### Cross-Training Protocols
- Deep water running (gold standard substitute maintaining fitness 6+ weeks)
- Cycling, elliptical, rowing, and swimming with time-equivalency ratios
- Strategic substitution during injury with graduated return-to-running
- Maintenance protocols for high-fatigue training periods

### Nutrition Integration
- Phase-specific macronutrient targets (5-12 g/kg carbohydrates based on training volume)
- Workout nutrition timing (pre/during/post protocols)
- Race week carbohydrate loading (10-12 g/kg for 36-48 hours pre-race)
- Race day fueling strategies (60-90g carbs hourly using dual-source carbohydrates)

## Target Users

**Committed runners** who can already run 2-3km comfortably and are preparing for their first marathon or improving marathon performance, seeking:
- Evidence-based training that adapts to their individual response and life circumstances
- Injury prevention through intelligent load management
- Integration of strength training, drills, and cross-training with running
- Clear guidance on nutrition, recovery, and when to push versus rest

**Not suitable for**:
- Complete beginners who cannot yet run 2-3km continuously
- Elite athletes requiring coach supervision and highly specialized programming
- Runners seeking purely performance-focused training without injury prevention emphasis

## Technical Architecture

### Core Components
- **Training Engine**: Periodization algorithms, load calculation, decision trees for workout modification
- **Monitoring System**: Multi-metric data collection (HRV, subjective recovery, sleep, training load), baseline establishment, trend analysis
- **Adaptation Logic**: Traffic light readiness assessment, graduated progression/reduction protocols, performance-based adjustments
- **Integration Layer**: Wearable device APIs (Garmin, Polar, Apple Watch), fitness platform connections, nutrition tracking

### Machine Learning Roadmap
**Phase 1 (Weeks 1-4)**: Session RPE collection, basic training load calculation, simple visualization
**Phase 2 (Weeks 5-8)**: TSB analytics, sleep tracking, alert systems for dangerous load patterns
**Phase 3 (Weeks 9-16)**: Decision tree implementation, HRV integration, recommendation engine
**Phase 4 (Weeks 17-24)**: LASSO regression for recovery prediction, individual response profiling
**Phase 5 (Ongoing)**: Advanced personalization, modality-specific recommendations, continuous model refinement

## Scientific Foundation

This application synthesizes research from:
- Training periodization and intensity distribution in elite distance runners
- Acute-to-chronic workload ratios and injury prevention in endurance athletes
- HRV-guided training showing elimination of low responders
- Strength training effects on running economy (meta-analyses of 4-8% improvements)
- Detraining timelines and return-to-training protocols
- Carbohydrate periodization and race nutrition strategies
- Cross-training equivalency and fitness maintenance during injury

Key research findings informing our approach:
- 80/20 intensity distribution (polarized training) optimal for marathon preparation
- Recovery weeks every 3-4 weeks with 20-25% volume reduction prevent overtraining
- ACWR above 1.5 shows 4-fold injury increase; sweet spot 0.8-1.3
- Heavy resistance (85-95% 1RM) + plyometrics produces strongest running economy gains
- Deep water running maintains VO2max for 6 weeks without land running
- Overnight HRV measured during sleep provides most reliable readiness data

## Getting Started

[Installation instructions to be added]

[API setup and wearable device connection guide to be added]

[Quick start guide for first-time users to be added]

## Contributing

We welcome contributions from researchers, coaches, developers, and runners with relevant expertise. Areas of particular interest:
- Additional validated monitoring metrics and decision algorithms
- Integration with additional wearable platforms
- Nutrition tracking and meal planning features
- Machine learning model improvements for individual response prediction
- Localization and accessibility enhancements

Please see CONTRIBUTING.md for guidelines.

## Research Citations & Further Reading

[Comprehensive bibliography of research papers informing the application to be added]

## License

[License to be determined]

## Acknowledgments

This project builds on decades of sports science research in exercise physiology, biomechanics, and periodization. We're particularly grateful to researchers studying:
- Individual variation in training response (Bouchard, Vollaard, Mann)
- Workload management and injury prevention (Gabbett, Soligard, Mujika)
- HRV-guided training protocols (Kiviniemi, Vesterinen)
- Running economy and strength training (Støren, Beattie, Barnes)
- Endurance training periodization (Seiler, Laursen)

---

**Status**: Active Development | **Version**: 0.1.0 (Pre-Alpha)

For questions, feature requests, or research collaboration inquiries, please open an issue or contact [contact information to be added].