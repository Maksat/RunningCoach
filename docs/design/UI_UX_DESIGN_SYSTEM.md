# RunningCoach UI/UX Design System & Strategy

## 1. Design Vision
**"The Tesla of Running Apps"**
RunningCoach is not just a tracker; it is an intelligent companion. The design must reflect **precision, science, and premium quality**.
*   **Aesthetic:** Dark mode first, futuristic, clean, data-rich but not cluttered.
*   **Feeling:** Empowering, Calm, Professional.
*   **Metaphor:** The "Cockpit". All critical instruments are visible, but the view is clear.

## 2. Visual Identity

### 2.1. Color Palette
We use a high-contrast dark theme to reduce battery consumption on OLED screens (common on phones and watches) and to reduce glare during early morning/late night runs.

#### Backgrounds
*   **Void Black:** `#050505` (Main Background - OLED friendly)
*   **Deep Slate:** `#0F172A` (Secondary Background / Cards)
*   **Surface Light:** `#1E293B` (Elevated Elements)

#### Primary Brand
*   **Electric Blue:** `#3B82F6` (Primary Actions, Active States)
*   **Neon Cyan:** `#06B6D4` (Gradients, Highlights)

#### Functional (The Traffic Light System)
*   **Go / Recovery Optimal:** `#10B981` (Emerald Green - Vibrant but readable)
*   **Caution / Adjust:** `#F59E0B` (Amber - Distinct from red)
*   **Stop / Rest Needed:** `#EF4444` (Red - Urgent)

#### Text
*   **Primary Text:** `#F8FAFC` (White - High legibility)
*   **Secondary Text:** `#94A3B8` (Blue Grey - Subtitles)
*   **Muted:** `#64748B` (Inactive labels)

### 2.2. Typography
We prioritize readability in motion.

*   **Font Family:** `Inter` (Google Fonts) or System Default (San Francisco on iOS, Roboto on Android) for performance.
*   **Headings:** Bold, tight tracking.
    *   H1: 32px (Hero Stats)
    *   H2: 24px (Section Headers)
*   **Body:** Regular, open tracking.
    *   Body: 16px
    *   Caption: 12px
*   **Data/Numbers:** `JetBrains Mono` or `Inter` with **Tabular Figures** (tnum) feature enabled to ensure numbers align vertically in lists and timers.

### 2.3. Iconography
*   **Style:** Thin stroke (1.5px or 2px), rounded corners.
*   **Library:** Lucide React or Heroicons (Outline).
*   **Active State:** Filled variants or Glow effect.

## 3. Component Library (The "Glass" System)

### 3.1. Cards & Containers
*   **Style:** Modern "Glassmorphism" but subtle to ensure performance.
*   **CSS:**
    ```css
    background: rgba(30, 41, 59, 0.7);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    ```
*   **Shadows:** Soft, diffuse colored shadows to indicate status (e.g., a green glow for a "Go" day).

### 3.2. Buttons
*   **Primary:** Electric Blue gradient background. Full width on mobile.
    *   `background: linear-gradient(135deg, #3B82F6 0%, #2563EB 100%);`
*   **Secondary:** Transparent with border.
*   **Ghost:** Text only, for less important actions.

### 3.3. Data Visualization
*   **Charts:** Minimalist. No grid lines unless necessary.
*   **Lines:** Smooth curves (Bézier). Gradient fill below the line (fade to transparent).
*   **Gauges:** Circular progress rings for "Readiness" and "Weekly Goal".

## 4. Interaction Design

### 4.1. Micro-interactions
*   **Heart Beat:** When viewing HR stats, the icon pulses at the actual BPM (if live) or a steady rhythm.
*   **Completion:** When a workout is marked complete, a satisfying "fill" animation triggers, followed by a confetti or particle effect.
*   **Loading:** Skeleton screens (shimmer effect) instead of spinners to perceive speed.

### 4.2. Gestures
*   **Swipe:**
    *   Swipe Right on a workout card: "Mark Complete".
    *   Swipe Left: "Reschedule/Skip".
*   **Long Press:**
    *   On a calendar day: Quick add "Life Event" (Sick, Travel).
    *   On a metric: Show definition/explanation.

### 4.3. Haptics
*   **Success:** Light, crisp tap (e.g., completing a form).
*   **Warning:** Double tap (e.g., trying to schedule a run on a rest day).
*   **Error:** Heavy vibration (e.g., destructive action).

## 5. Key Screen Visuals

### 5.1. The "Today" Dashboard
*   **Hero Section:** A large, breathing circular indicator of **Readiness**.
    *   **Green Day:** Ring is green, pulsing slowly. Text: "Ready to Train".
    *   **Red Day:** Ring is red, static. Text: "Rest Required".
*   **Workout Card:**
    *   Dominates the center.
    *   Background: Subtle map texture or abstract gradient.
    *   Key Stat (e.g., "12 km") is massive (48px).

### 5.2. The "Plan" Calendar
*   **View:** Infinite scroll vertical list (Agenda view) is often better for mobile than a small grid.
*   **Visuals:**
    *   Days are connected by a "timeline" line.
    *   Past days are dimmed.
    *   Future days are bright.
    *   "Race Day" is a gold/glowing flag at the end of the scroll.

### 5.3. The "Morning Check-In"
*   **Layout:** Bottom sheet modal.
*   **Input:** Large sliders for Sleep/Mood.
*   **Feedback:** As you slide, the background color shifts subtly (Red -> Yellow -> Green) to give instant feedback on what the value means.

## 6. Accessibility
*   **Contrast:** All text must meet WCAG AA standards (4.5:1).
*   **Touch Targets:** Minimum 44x44px for all interactive elements.
*   **Dynamic Type:** Support system font scaling.
*   **Color Blindness:** Never rely on color alone. Use icons (Checkmark vs Warning Triangle) alongside Green/Red colors.

## 7. Implementation Roadmap
1.  **Phase 1: Wireframes:** Low-fidelity layout of all 5 tabs.
2.  **Phase 2: Design System:** Build the Figma component library (Colors, Typography, Buttons).
3.  **Phase 3: High-Fidelity Prototypes:** "Today" and "Plan" flows fully visualized.
4.  **Phase 4: Motion Design:** Prototyping the transitions and micro-interactions.
