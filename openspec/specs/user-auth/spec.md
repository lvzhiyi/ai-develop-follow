# user-auth Specification

## Purpose

Provide an explicit local demo login with a replaceable authentication boundary.

## Requirements

### Requirement: Demo login
The app SHALL accept demo@example.com with password demo12345 through the demo repository and SHALL label authentication as local-only.

#### Scenario: Correct credentials
- **WHEN** the user submits valid demo credentials
- **THEN** an in-memory session is created and Home is shown

#### Scenario: Invalid credentials
- **WHEN** the user submits incorrect credentials
- **THEN** an error is shown, loading ends and the user can retry

### Requirement: Session routing
The app SHALL guard Home for unauthenticated users and SHALL clear the session on logout without persisting credentials.

#### Scenario: Open protected page
- **WHEN** an unauthenticated user requests Home
- **THEN** the user is redirected to login

#### Scenario: Logout
- **WHEN** the user signs out
- **THEN** login is shown and Home remains protected

#### Scenario: Restart
- **WHEN** a fresh application session starts
- **THEN** the user is unauthenticated
