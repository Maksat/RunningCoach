# Screen: Workout Details
**ID:** DASH-03
**Parent Flow:** Dashboard -> Workout Card Tap

## 1. Purpose
Detailed view of the specific workout, explaining the "Why" and the structure.

## 2. Layout & Structure
*   **Type:** Full Screen or Expanded Card.
*   **Header:** "Back" arrow.

## 3. UI Components

### 3.1. Header Info
*   **Title:** "Long Run - Aerobic Base"
*   **Subtitle:** "18 km • Target: Zone 2 (135-145 bpm)"

### 3.2. The "Why" (Science)
*   **Component:** Accordion / Collapsible Section.
*   **Title:** "Why this workout?"
*   **Content:** "Long runs increase mitochondrial density and capillary beds. Keeping it in Zone 2 ensures we target fat oxidation without accumulating too much fatigue."

### 3.3. Structure (Steps)
*   **List:**
    *   1. Warm Up: 10 min @ Easy
    *   2. Main Set: 18 km @ Zone 2
    *   3. Cool Down: 5 min Walk
*   **Visual:** Simple timeline visualization.

### 3.4. Actions
*   **Button:** "Push to Garmin" (if connected).
*   **Button:** "Mark as Complete" (Manual Log).

## 4. Dynamic Data
*   **Workout Structure:** Parsed from JSON workout definition.

## 5. Design System References
*   **Typography:** Clear hierarchy. "Why" section uses `Secondary Text` color.
