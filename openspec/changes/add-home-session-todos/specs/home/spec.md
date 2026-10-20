## REMOVED Requirements

### Requirement: Home screen
**Reason**: PRD v1.0 explicitly replaces the counter example, so its Increment example scenario is intentionally retired rather than silently omitted.
**Migration**: Use the Home todo screen requirement below; preserve identity, logout and responsive behavior while replacing counter tests with todo tests.

## ADDED Requirements

### Requirement: Home todo screen
The app SHALL display the demo user, a session-local personal todo area and a logout action after login, replacing the counter example without introducing another page.

#### Scenario: Initial Home
- **WHEN** a user logs in with a fresh session
- **THEN** Home shows the user identity and logout action
- **AND** the counter example is absent and the todo area shows “还没有待办，添加第一项吧”

#### Scenario: Present existing session todos
- **WHEN** the current session contains todos
- **THEN** Home displays their titles and completion states in newest-created-first order

#### Scenario: Responsive presentation
- **WHEN** the viewport is narrow or the keyboard is visible
- **THEN** content remains accessible by scrolling
- **AND** light/dark themes and system text scaling remain supported
