# RFC 0006: Sync Infrastructure

| Status        | Draft |
| :---          | :--- |
| **RFC #**     | 0006 |
| **Author(s)** | Systems Engineer |
| **Created**   | 2025-11-26 |
| **Updated**   | 2025-11-26 |

## 1. Introduction

### 1.1. Context
RunningCoach requires an "Offline-First" experience. Users must be able to view plans and log runs without internet. Data must sync reliably when connection is restored.

### 1.2. Goals
*   **Reliability:** No data loss.
*   **Efficiency:** Delta sync (only changes).
*   **Conflict Handling:** Smart resolution strategies.

## 2. Proposed Solution

### 2.1. Technology: WatermelonDB Sync
We will utilize WatermelonDB's built-in Sync Protocol.

### 2.2. Protocol Overview
1.  **Pull (Backend -> Client):**
    *   Client sends `last_pulled_at` timestamp.
    *   Backend returns `{ changes: { created: [], updated: [], deleted: [] }, timestamp: new_timestamp }`.
2.  **Push (Client -> Backend):**
    *   Client sends `{ changes: { created: [], updated: [], deleted: [] }, last_pulled_at }`.
    *   Backend applies changes.
    *   If conflict (record changed on server since `last_pulled_at`), Backend resolves it.

### 2.3. Backend Implementation
*   **Deleted Flag:** We will use "Soft Deletes" (`deleted_at` column) to track deletions for sync.
*   **Timestamps:** Every table needs `created_at` and `updated_at`.
*   **Sync Endpoint:** `POST /api/v1/sync`.

### 2.4. Conflict Resolution Strategies

| Entity | Strategy | Rationale |
| :--- | :--- | :--- |
| **Activity (GPS)** | **Merge (Source Priority)** | Garmin GPS > Manual GPS. |
| **Activity (Notes)** | **Client Wins** | User edits on phone are most recent intent. |
| **Plan** | **Server Wins** | The "Brain" (Server) logic supersedes manual tinkering if re-optimization runs. |
| **Settings** | **Last Write Wins** | Standard approach. |

### 2.5. Large File Handling (FIT Files)
*   WatermelonDB sync is for *metadata* and *JSON* data.
*   **Binary Files (FIT/Images):**
    *   Upload separately to S3 via Signed URLs.
    *   Sync the *reference* (URL/Key) in the database.
    *   **Queue:** Use a separate `FileUploadQueue` in the app to retry failed uploads.

## 3. Implementation Plan

### 3.1. Phase 1: Basic Sync
*   Implement `pullChanges` endpoint.
*   Implement `pushChanges` endpoint.
*   Connect WatermelonDB frontend.

### 3.2. Phase 2: Conflict Handling
*   Implement specific resolution logic for Activities.

## 4. Open Questions
*   **Initial Sync:** How to handle the first massive pull?
    *   *Solution:* Pagination or "Turbo Sync" (download pre-packaged SQLite DB file). For MVP, standard sync is likely fine for < 10k records.
