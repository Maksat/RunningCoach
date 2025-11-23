# PRD: External Integrations & Third-Party APIs

## 1. Introduction
This document defines integrations with external services that enhance the RunningCoach experience beyond wearable data. These integrations provide race discovery, environmental data, nutrition tracking, and other context-aware features.

**Scope:** Non-wearable external APIs. For wearable device integration, see [03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md).

## 2. Race Discovery & Planning (Ahotu)

### 2.1. Purpose
Allow users to find target races and automatically populate training calendars with accurate race dates, distances, and course profiles.

### 2.2. Integration Type
**API:** Search & Retrieve (read-only)

### 2.3. Data Points
*   Race Name, Date, Location (City, State, Country)
*   Distance (Marathon, Half Marathon, 10K, 5K, etc.)
*   Course Profile: Elevation gain/loss, course map
*   Registration URL
*   Race website and contact info

### 2.4. Workflow
1. User searches for races by location, date range, or distance
2. Backend queries Ahotu API with search parameters
3. Results displayed in app with key details
4. User selects a race
5. Backend imports race details and triggers **Periodization Engine** to build plan backward from race date
6. Training plan generated with appropriate taper aligned to race day

### 2.5. Success Metrics
*   ≥80% of race searches return relevant results
*   <2 second search latency
*   Accurate race date (no postponements/cancellations without updates)

## 3. Environmental Data (Weather Services)

### 3.1. Purpose
Adjust training intensity expectations and provide safety alerts based on environmental stress (heat, humidity, wind, air quality).

### 3.2. Integration Type
**API:** OpenWeatherMap, AccuWeather, or similar

### 3.3. Data Points
*   Temperature (°C/°F)
*   Humidity (%)
*   Dew Point (calculated if not provided)
*   Wind Speed & Direction
*   Air Quality Index (AQI)
*   UV Index
*   7-day forecast

### 3.4. Use Cases

**Pre-Workout Planning:**
*   7-day forecast used to suggest moving long runs or hard workouts to cooler days/times
*   "Tomorrow's long run: high of 32°C (90°F), consider starting at 6 AM or moving to Sunday"

**Pre-Run Guidance ("Coach's Note"):**
*   Display "Feels Like" temperature with hydration advice
*   "It's 28°C with 70% humidity today. This will feel like 34°C. Hydrate well and expect 10-15 seconds/km slower pace."

**Post-Run Analysis:**
*   Backend adjusts "Effort Score" using Grade Adjusted Pace (GAP) + Weather adjustment
*   A slow run in 35°C heat might be scored as high-performance effort
*   Prevents unfair negative assessment due to environmental factors

**Safety Alerts:**
*   AQI >150: "Air quality is unhealthy. Consider indoor training or light activity only."
*   Heat Index >38°C (100°F): "Extreme heat alert. Shorten workout or move indoors."

### 3.5. Performance Adjustment Thresholds
Based on research (see [06_ADAPTIVE_TRAINING_ENGINE.md](./06_ADAPTIVE_TRAINING_ENGINE.md)):
*   Dew Point < 15°C (60°F): No adjustment
*   Dew Point 15-21°C (60-70°F): Adjust pace 1-3% slower
*   Dew Point 21-24°C (70-75°F): Adjust pace 3-6% slower
*   Dew Point > 24°C (75°F): Switch to HR/RPE targets only, pace irrelevant

### 3.6. Success Metrics
*   Weather data accuracy ≥95% (validate against actual conditions)
*   Forecast fetched ≥12 hours before workout
*   Safety alerts delivered ≥2 hours before scheduled workout

## 4. Nutrition & Fueling (MyFitnessPal)

### 4.1. Purpose
Monitor energy availability and macronutrient balance to ensure athletes fuel adequately for training load.

### 4.2. Integration Type
**API:** OAuth2 with MyFitnessPal

### 4.3. Data Points
*   **Daily Totals:** Calories consumed, Carbohydrates (g), Protein (g), Fat (g)
*   **Meal Timing (Future/Optional):** Time of meals relative to workouts

### 4.4. Privacy Considerations
*   Request only daily summary data, NOT specific food item logs
*   Respect user privacy—nutrition is sensitive information
*   Optional integration—not required for core functionality

### 4.5. Use Cases

**RED-S Risk Detection:**
*   If Calories In < Calories Out significantly for prolonged periods (>7 days, >500 kcal/day deficit during heavy training), flag as Relative Energy Deficiency in Sport (RED-S) risk
*   Alert: "Your calorie intake appears low for your training load. Consider consulting a sports nutritionist."

**Macronutrient Targets:**
*   Check if Protein/Carb targets are missed during heavy training blocks
*   Target ranges: Carbs 5-12 g/kg/day, Protein 1.2-2.0 g/kg/day (see [10_NUTRITION_FUELING.md](./10_NUTRITION_FUELING.md))
*   Guidance: "You're averaging 3 g/kg carbs this week. For peak training, aim for 8-10 g/kg."

**Race Week Carb Loading:**
*   Track progress toward 10-12 g/kg target during 36-48 hours pre-race
*   Notification: "Race day in 36 hours. Aim for 700g carbs today (10 g/kg for your weight)."

### 4.6. Success Metrics
*   ≥60% of users who enable MyFitnessPal integration maintain connection >30 days
*   <1% report privacy concerns
*   Calorie/macro targets displayed within 5% accuracy

## 5. Future Integrations (Roadmap)

### 5.1. Smart Scales (Withings, Garmin Index)
**Purpose:** Track weight and body composition trends
**Data:** Weight, body fat %, muscle mass, hydration
**Use Case:** Detect unintended weight loss during heavy training (RED-S indicator), monitor taper weight gain (glycogen + water = expected)

### 5.2. Continuous Glucose Monitors (CGM)
**Providers:** Supersapiens, Abbott FreeStyle Libre
**Purpose:** Real-time fueling insights during long runs
**Data:** Blood glucose levels (mg/dL)
**Use Case:** Optimize race-day fueling strategy, detect "bonking" risk before it happens, personalize gel/carb intake timing

### 5.3. Treadmill & Indoor Equipment
**Providers:** Zwift Run, Peloton Tread
**Purpose:** Accurate indoor run data
**Data:** Pace, incline, distance, HR
**Use Case:** Count indoor runs toward weekly volume with accurate load calculation

### 5.4. Gym Equipment & Connected Devices
**Providers:** Concept2 (rowing), Peloton Bike
**Purpose:** Track cross-training with precision
**Data:** Power, cadence, resistance, distance
**Use Case:** Accurate cross-training load for ACWR calculations

## 6. Integration Architecture

### 6.1. Plugin-Style Adapter Pattern
*   Each external service has dedicated adapter module
*   Standardized interface: `fetch()`, `normalize()`, `store()`
*   New integrations added without core system changes

### 6.2. Webhook & Polling Strategy
*   **Webhooks Preferred:** Real-time updates when supported
*   **Polling Fallback:** Daily/hourly polling for services without webhooks
*   **On-Demand:** User-triggered manual refresh

### 6.3. Error Handling
*   External API failures do not break core functionality
*   Graceful degradation: display cached data or "Currently unavailable"
*   Retry with exponential backoff (max 3 attempts)
*   Log failures for monitoring

## 7. Data Privacy & Security

### 7.1. OAuth2 Standard
*   All third-party integrations use OAuth2 for secure authorization
*   **Never store user passwords** for external services
*   Access & Refresh tokens encrypted at rest (AES-256)

### 7.2. Data Minimization
*   Request only necessary scopes (e.g., `nutrition:read`, `races:read`)
*   Do not request write permissions unless bidirectional sync required
*   Fetch data incrementally, not full history

### 7.3. User Control
*   **Connect:** Initiate OAuth flow via in-app button
*   **Disconnect:** Revoke access anytime (deletes tokens and optionally historical data)
*   **Selective Sync:** Choose which metrics to import (future enhancement)

### 7.4. Data Retention
*   Store only aggregated summaries, not raw external data
*   Example: Store "Daily Carbs: 350g" not "Breakfast: Oatmeal, 45g carbs..."
*   Comply with GDPR data export and deletion requests

## 8. Rate Limiting & Quotas

### 8.1. Respect Vendor Limits
*   Track API quota usage per service
*   Implement client-side rate limiting to stay within bounds
*   Example: Ahotu may limit 1000 searches/day—enforce 100 searches/user/day

### 8.2. Caching Strategy
*   Cache weather forecasts for 1 hour (rarely changes within that window)
*   Cache race search results for 24 hours (race details don't change daily)
*   Cache nutrition daily totals after day ends (immutable)

## 9. Monitoring & Reliability

### 9.1. Health Checks
*   Periodic health checks for each integration (daily)
*   If API down for >6 hours, display in-app notice: "Weather data temporarily unavailable"

### 9.2. Metrics
*   **API Availability:** % uptime per service
*   **Response Time:** p95 latency for each API
*   **Error Rate:** % of requests returning errors
*   **User Adoption:** % of users enabling each integration

### 9.3. Fallback Behavior
*   **Weather unavailable:** Use last known forecast, disable environmental adjustments
*   **Race database down:** Allow manual race entry (name, date, distance)
*   **Nutrition API down:** Prompt manual entry of daily macros

## 10. Success Metrics
*   **Integration Reliability:** >99% uptime for critical services (weather)
*   **User Adoption:** ≥40% of users enable at least one external integration
*   **Data Freshness:** Weather data <1 hour old, nutrition data synced daily
*   **User Satisfaction:** <2% disconnect rate due to issues (vs. personal choice)

## 11. Related PRDs
*   [00_OVERARCHING_VISION.md](./00_OVERARCHING_VISION.md) - Holistic training approach
*   [03_WEARABLE_INTEGRATION.md](./03_WEARABLE_INTEGRATION.md) - Wearable-specific integrations
*   [05_SYNC_INFRASTRUCTURE.md](./05_SYNC_INFRASTRUCTURE.md) - Internal sync after external data imported
*   [06_ADAPTIVE_TRAINING_ENGINE.md](./06_ADAPTIVE_TRAINING_ENGINE.md) - Consumes environmental and nutrition data
*   [10_NUTRITION_FUELING.md](./10_NUTRITION_FUELING.md) - Nutrition targets and protocols
