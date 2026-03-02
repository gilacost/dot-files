# Workflow Analysis System

**Goal:** Track your actual workflow to find bottlenecks, then optimize the right things.

---

## How This Works

### 1. Track for 2-3 Days

Run `workflow-start` at the beginning of your coding session. It'll passively log:
- Commands you run frequently
- Files you navigate to
- Time spent in different tools
- Context switches (terminal ↔ nvim)

### 2. Analyze the Data

Run `workflow-analyze` to see:
- Most common operations
- Navigation patterns
- Slow workflows
- Repetitive tasks

### 3. Optimize

Based on the data, we'll create **targeted improvements** for your actual pain points.

---

## Quick Start

```bash
# Start tracking (runs in background)
workflow-start

# Code normally for 2-3 days

# Analyze your workflow
workflow-analyze

# See specific bottlenecks
workflow-bottlenecks
```

---

## What We'll Discover

### File Navigation
- How do you currently navigate between files?
  - Telescope? `:e`? Harpoon? File tree?
- Which files do you switch between most?
- How many keystrokes does navigation take?

### Tool Usage
- How often do you switch terminal ↔ nvim?
- What commands do you run most in terminal?
- How much time in git operations?

### AI Usage
- When do you use Claude vs Avante vs Codeium?
- What prompts are repetitive?
- Where do file conflicts happen?

### Time Sinks
- Where do you wait?
- What do you repeat manually?
- What breaks your flow?

---

## Implementation

The tracker will be:
- **Passive** - doesn't interfere with work
- **Private** - logs stay local (.gitignored)
- **Simple** - just timestamps + commands
- **Actionable** - shows clear opportunities

---

## Example Output

After 3 days of tracking:

```
=== Workflow Analysis (Jan 10-12, 2026) ===

Top Commands (terminal):
  1. git status (47 times) - 🔴 CANDIDATE FOR ALIAS
  2. git diff (31 times)
  3. npm test (28 times)
  4. cd ../.. (19 times) - 🔴 CANDIDATE FOR JUMP/ZOXIDE
  5. ls -la (15 times)

File Navigation (nvim):
  - Most opened: src/app.js (23 times)
  - Most switched: app.js ↔ utils.js (12 times) - 🔴 CANDIDATE FOR HARPOON
  - Avg time to open file: 4.2 seconds - 🔴 SLOW, optimize telescope?

Context Switches:
  - nvim → terminal: 89 times
  - Reason: Running tests manually - 🔴 CANDIDATE FOR :TestNearest

AI Usage:
  - Claude Code: 12 sessions
  - File conflicts: 3 times - 🔴 FIX NEEDED
  - Most common prompt: "fix tests" - 🔴 CANDIDATE FOR ALIAS

Time Breakdown:
  - Coding: 4.2 hours (70%)
  - Testing: 0.8 hours (13%)
  - Git operations: 0.5 hours (8%)
  - Navigation/searching: 0.5 hours (8%) - 🔴 HIGH, optimize this
```

---

## Then We'll Create

Based on YOUR data:

### Scenario 1: You navigate files manually a lot
**Solution:** Set up Harpoon for your most-used files

### Scenario 2: You run the same git commands repeatedly
**Solution:** Smart git aliases or AI helpers (we already added these!)

### Scenario 3: You switch terminal→nvim to run tests
**Solution:** Neovim test integration (you already have this, maybe not using it?)

### Scenario 4: You spend time searching for files
**Solution:** Better telescope config or alternative

### Scenario 5: File conflicts with Claude
**Solution:** Our AI pair workflow (but only the parts you need)

---

## Ready to Start?

Want me to create the tracker, or would you prefer to manually track for a day or two and tell me your pain points?

**Manual tracking (faster to start):**
Just pay attention today and note:
1. What commands do you run most?
2. What's annoying/slow in your workflow?
3. What do you repeat that could be automated?

**Automated tracking (more accurate):**
I'll create a simple logger that tracks your shell history and nvim usage.

Which approach do you prefer?
