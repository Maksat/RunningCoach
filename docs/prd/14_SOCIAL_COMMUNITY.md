# 14_SOCIAL_COMMUNITY

## 1. Introduction
This document outlines the social and community features of the RunningCoach application. While the core of RunningCoach is individual adaptive training, social connection is a critical driver of retention and motivation. The goal is to create a supportive, non-toxic environment that fosters consistency and accountability.

## 2. Core Philosophy: "Connection over Comparison"
Unlike Strava, which often prioritizes speed and public performance (leading to "comparison fatigue"), RunningCoach's social features prioritize **consistency, effort, and mutual support**.
*   **Anti-Goal:** We do not want users to feel bad about their pace or distance.
*   **Pro-Goal:** We want users to feel celebrated for showing up, regardless of the outcome.

## 3. Key Features

### 3.1. Clubs & Squads
Small, private or semi-private groups designed for accountability.
*   **Squads:** User-created groups (e.g., "Office Runners", "Marathon Training Group").
    *   **Limit:** Capped at ~50 members to maintain intimacy.
    *   **Shared Goals:** Ability to set a collective goal (e.g., "Run 1000km total in January").
    *   **Chat:** Simple threaded chat for coordination and encouragement.
*   **Official Clubs:** Managed by RunningCoach (e.g., "Sub-4 Marathoners", "New Runners").
    *   **Content:** Exclusive tips and challenges for club members.

### 3.2. Friend Feed
A simplified activity feed focused on effort.
*   **Content:** Shows completed workouts of friends.
*   **Privacy:** Users can choose to hide specific metrics (e.g., hide pace/heart rate, show only distance/time).
*   **Interactions:**
    *   **Kudos:** A simple "high five" to acknowledge effort.
    *   **Comments:** Text-based encouragement.
*   **No "Doom Scrolling":** The feed is strictly chronological and algorithm-free.

### 3.3. Consistency Leaderboards
Leaderboards that reward habit formation rather than raw athletic ability.
*   **Metric:** "Days Active", "Streak Length", "Total Time Moving".
*   **Scope:** Weekly and Monthly views.
*   **Groups:** Leaderboards are scoped to Squads/Clubs, not global (to avoid cheating/bots).

### 3.4. "Running Buddy" Finder (Future)
*   **Concept:** Match users with similar paces and locations for real-world runs.
*   **Safety:** Opt-in only, requires identity verification (future scope).

## 4. Integration with Mobile Client
*   **Tab:** A dedicated "Community" tab in the bottom navigation (see `01_MOBILE_CLIENT.md`).
*   **Notifications:** Push notifications for Kudos, comments, and Squad challenges.
