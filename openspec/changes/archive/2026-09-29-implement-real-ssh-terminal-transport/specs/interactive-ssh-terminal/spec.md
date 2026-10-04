# Spec Delta

## Purpose

Defines an interactive mobile terminal connected to a real remote SSH pseudo-terminal while preserving responsive rendering, session isolation, and deterministic cleanup.

## ADDED Requirements

### Requirement: Connected sessions expose an interactive remote terminal
After SSH authentication Surf Terminal SHALL request a remote PTY and interactive shell, render server output through a terminal emulator, and send user input to that shell. Synthetic preview output MUST NOT be mixed with a connected session.

#### Scenario: Remote shell starts
- **WHEN** authentication succeeds and the server grants a PTY and shell
- **THEN** the terminal accepts keyboard input and renders remote stdout and stderr-compatible shell output

#### Scenario: User enters a command
- **WHEN** the user types into the terminal and submits input
- **THEN** the encoded bytes are sent to the active remote shell and resulting output is rendered by the terminal emulator

#### Scenario: PTY creation is rejected
- **WHEN** the server refuses the PTY or shell request
- **THEN** the session enters a typed failure state and does not display an interactive connected terminal

### Requirement: Terminal output bypasses global state rebuilds
High-frequency terminal bytes SHALL stream directly into a session-owned terminal buffer. Serialized workflow state MUST contain lifecycle and metadata only and MUST NOT accumulate terminal transcript content.

#### Scenario: Server emits sustained output
- **WHEN** the remote shell produces many output chunks
- **THEN** chunks update the active terminal buffer without emitting one global application state for each chunk

#### Scenario: Session tab is inactive
- **WHEN** output arrives for a connected background tab
- **THEN** its own buffer continues receiving data without replacing another tab's buffer or forcing whole-app rebuilds

### Requirement: Terminal dimensions synchronize with the remote PTY
The terminal SHALL send initial columns and rows when opening the PTY and SHALL debounce subsequent resize updates caused by orientation, keyboard, or layout changes.

#### Scenario: Terminal viewport size changes
- **WHEN** measured terminal columns or rows change
- **THEN** the active shell receives the latest dimensions after debounce without a resize request for every layout frame

### Requirement: Mobile terminal controls send correct input
The terminal SHALL support ordinary keyboard input plus Escape, Control combinations, Alt combinations, Tab, arrow keys, paste, and keyboard dismissal. Sensitive clipboard content MUST NOT be logged.

#### Scenario: User taps the terminal viewport
- **WHEN** a connected terminal is visible and the user taps its input area
- **THEN** the terminal receives focus, the platform software keyboard opens, and subsequent text is sent to that active session

#### Scenario: Special-key toolbar is used
- **WHEN** the software keyboard is open and the user taps a terminal toolbar key
- **THEN** the key sequence is sent without unintentionally stealing terminal focus or closing the keyboard

#### Scenario: Keyboard is dismissed and reopened
- **WHEN** the user dismisses the software keyboard and later taps the terminal viewport again
- **THEN** the same active terminal can reacquire focus and open the keyboard again

#### Scenario: User sends Control-C
- **WHEN** Control mode is active and the user presses C
- **THEN** the terminal sends the corresponding control byte to the active remote shell

#### Scenario: User pastes text
- **WHEN** the user confirms paste into the connected terminal
- **THEN** the text is sent to that session only and is not copied into analytics, logs, or persistent transcript storage

### Requirement: Each terminal tab owns and cleans up one session scope
Every tab SHALL own an isolated SSH client, shell channel, terminal buffer, stream subscriptions, lifecycle controller, and cleanup path. Closing a tab or leaving a terminated session MUST release all related resources deterministically.

#### Scenario: User opens two profiles
- **WHEN** two terminal tabs are connected
- **THEN** input, output, status, resize, and disconnect actions remain isolated by session identity

#### Scenario: User closes a connected tab
- **WHEN** tab closure is confirmed
- **THEN** subscriptions, shell, socket, retry timers, and sensitive transient values for that tab are released

### Requirement: Connection status and recovery remain visible
The terminal route SHALL present lifecycle status, host identity, retry or reconnect action, and explicit disconnect without obscuring terminal content or falsely claiming connectivity.

#### Scenario: Session reconnects
- **WHEN** an active connection is temporarily lost
- **THEN** the terminal remains associated with the same profile, visibly indicates reconnecting, and does not accept input as if the old shell were active

#### Scenario: User retries manually
- **WHEN** the session is failed or disconnected and the user selects retry
- **THEN** a new verified authentication and shell lifecycle begins for the same profile
