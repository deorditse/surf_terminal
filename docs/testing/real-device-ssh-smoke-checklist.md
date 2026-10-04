# Real-device SSH terminal smoke checklist

Use this checklist on at least one physical Android or iOS device against user-owned test infrastructure. Do not place credentials, private keys, host fingerprints, terminal transcripts, or identifiable endpoints in this file, screenshots, command arguments, logs, or chat.

## Preconditions

- Install a locally built Surf Terminal package on the device.
- Create a disposable account and endpoint outside the repository.
- Enter the password only through the app UI; do not retain it in test automation.
- Record only pass/fail outcomes and sanitized failure categories.

## Keyboard and PTY checks

- [ ] Select the test profile, complete explicit host-key trust, and reach a verified connected shell.
- [ ] Tap the terminal viewport and confirm the system software keyboard appears.
- [ ] Type ASCII and non-ASCII text and confirm the remote PTY receives it exactly once.
- [ ] Use Escape, Control, Alt, Tab, arrow, and paste toolbar actions; confirm the terminal retains focus.
- [ ] Dismiss the keyboard and confirm the SSH session remains connected.
- [ ] Tap the terminal again and confirm the software keyboard reopens.
- [ ] Rotate the device or otherwise change the viewport while the keyboard is visible; confirm the remote PTY receives the final columns/rows and terminal content remains usable.
- [ ] Background and foreground the app; confirm the UI reports the actual session state and never claims an unverified connection.
- [ ] Disconnect and close the tab; confirm no terminal input or output continues.

## Redacted outcome

- Platform/device class: _not executed_
- Build identifier: _not executed_
- Result: **BLOCKED — physical-device execution required**
- Sanitized notes: none
