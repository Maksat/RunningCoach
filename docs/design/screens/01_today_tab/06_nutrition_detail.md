# Screen: Nutrition Detail
**ID:** DASH-06
**Parent Flow:** Dashboard -> Nutrition Card

## 1. Purpose
Provides a detailed breakdown of daily nutrition targets, meal timing advice, and hydration strategies based on the day's training load.

## 2. Layout & Structure
*   **Type:** Modal or Detail Page.
*   **Visuals:** Clean, data-focused, appetizing imagery (optional).

## 3. UI Components

### 3.1. Daily Targets (Hero)
*   **Visual:** Ring Charts for Macros.
*   **Data:**
    *   **Carbs:** "450g / 500g" (Progress bar).
    *   **Protein:** "120g / 140g".
    *   **Fats:** "60g / 70g".
*   **Context:** "High Carb Day" (Badge).
*   **Explanation:** "Today is a long run day. We've increased your carb target to support glycogen stores."

### 3.2. Meal Timing Timeline
*   **Component:** Vertical Timeline.
*   **Items:**
    *   **Pre-Workout (2h before):** "Oatmeal + Banana (60g Carbs)".
    *   **During Workout:** "1 Gel every 45 mins".
    *   **Post-Workout (Window open):** "Recovery Shake (30g Protein + 60g Carbs)".
    *   **Dinner:** "Balanced meal with lean protein".

### 3.3. Hydration Strategy
*   **Visual:** Water Bottle Icon / Counter.
*   **Target:** "3.5L Goal".

### 3.4. Tools
*   **Button:** "Log Meal" (Link to MyFitnessPal or simple internal logger).
*   **Button:** "Scan Barcode" (if internal logging supported).

## 4. Dynamic Data
*   **Targets:** Calculated from `NutritionEngine` based on `DailyTrainingLoad`.
*   **Weather:** Influences hydration advice.

## 5. Design System References
*   **Colors:**
    *   Carbs: Wheat/Gold.
    *   Protein: Blue/Purple.
    *   Fats: Avocado Green.
