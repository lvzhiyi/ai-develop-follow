# Personal Todos Delta

## Purpose

Provide a session-local foundation for displaying personal todos, stable identities and creation order, with empty states and session cleanup. This change defines read-only presentation without backend access or persistent storage.

## ADDED Requirements

### Requirement: Session-local todo list
The app SHALL start each new authenticated session with an empty todo list, clear all todos after logout, browser refresh or application restart, and display the initial empty message “还没有待办，添加第一项吧”.

#### Scenario: Fresh session
- **WHEN** a user logs in for the first time in this application session
- **THEN** no seeded production todos are present and the initial empty message is shown

#### Scenario: Logout then login
- **WHEN** a user logs out with existing todos and logs in again
- **THEN** the new session is empty and no previous-session todos remain

#### Scenario: Refresh or restart
- **WHEN** the browser refreshes or the application restarts
- **THEN** no todos are restored and the existing authentication guard requires login

### Requirement: Stable identity and creation order
Each todo SHALL have a unique stable identity within its session and a title and completion state. Todos SHALL be shown in newest-created-first order, allow repeated titles, and display each recorded completion state without changing creation order.

#### Scenario: Same-title tasks
- **WHEN** two todos have the same title
- **THEN** they remain separate entries with distinct identities

#### Scenario: Closely created tasks
- **WHEN** the current session contains multiple todos recorded consecutively
- **THEN** their identities are distinct and their order follows creation order rather than title or completion state

### Requirement: Immutable todo snapshots
The system SHALL expose todo state as immutable snapshots so consumers cannot mutate an existing list or record and silently change the displayed session state.

#### Scenario: Read an existing snapshot
- **WHEN** a consumer reads the current todo snapshot
- **THEN** its records and list cannot be modified externally
- **AND** stable identities, titles, completion states and creation order remain intact
