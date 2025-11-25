# Screen: Progress Analytics
**ID:** PROG-01
**Parent Flow:** Main Navigation (Tab 3)

## 1. Purpose
Long-term tracking of adaptation, fitness trends, and injury risk management.

## 2. Layout & Structure
*   **Type:** Vertical Scroll of Chart Cards.

## 3. UI Components

### 3.1. Chart 1: Injury Risk (ACWR)
*   **Title:** "Load Management (ACWR)"
*   **Visual:** Line Chart.
    *   **Y-Axis:** Ratio (0.5 - 2.0).
    *   **Zones:**
        *   Green Band (0.8 - 1.3) "Sweet Spot".
        *   Red Zone (> 1.5) "High Risk".
    *   **Line:** User's daily ACWR.
*   **Interaction:** Tap for details (`PROG-02`).

### 3.2. Chart 2: Fitness vs. Fatigue (TSB)
*   **Title:** "Training Status"
*   **Visual:** Dual Area Chart or Bar Chart.
    *   **Fitness (CTL):** Blue line (Slow moving).
    *   **Fatigue (ATL):** Pink line (Spiky).
    *   **Form (TSB):** Bar chart at bottom (Positive/Negative).

## 4. Dynamic Data
*   **Source:** Calculated from historical `InternalLoad` data.

## 5. Design System References
*   **Charts:** Minimalist, no grid lines. `Recharts` or `Victory` style.
*   **Colors:** ACWR zones use Traffic Light transparency.
