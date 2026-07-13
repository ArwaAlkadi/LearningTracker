# Learning Tracker

**Build the habit. Protect the streak.**

Learning Tracker is an iOS app that helps users build consistent learning habits by tracking daily progress and streaks. Set a personal learning goal, pick a plan duration, and log every day — or freeze it when life gets in the way.

<br>
<img width="1920" height="1080" alt="LearningTracker2025" src="https://github.com/user-attachments/assets/8b51cd02-a926-4879-aa67-d065db8684bd" />
<br>
<br>

## Features

- **Personal learning goal** with a plan duration: week, month, or year
- **Daily logging** — mark each day as *learned* (orange) or *frozen* (blue) on a live calendar
- **Streak tracking** with a grace window, so one busy evening doesn't erase your progress
- **Freeze days** — a limited budget of guilt-free breaks that pause the streak without breaking it
- **Streak warning notification** — a reminder before the streak expires
- **Change goal flow** — start a new goal or restart the same one, resetting progress cleanly
<br>



## How It Works

### Streaks with a Grace Window
A streak doesn't die at midnight. It survives as long as no more than **32 hours** pass between logs — enough slack to log at 9 PM one day and 11 PM the next. Exactly **22 hours** after the last log, the app schedules a single local notification: *"Only 10 hours left to log in and keep your progress going"* — timed so the warning always lands with exactly the grace that remains. Every new log or freeze reschedules it.

### Freeze Days
Freezes are deliberate, budgeted rest days that scale with the plan:

| Plan | Duration | Freeze budget |
|---|---|---|
| Week | 7 days | 2 freezes |
| Month | 30 days | 8 freezes |
| Year | 365 days | 96 freezes |

A frozen day counts toward the plan and keeps the streak alive, but only one action (learn or freeze) is allowed per day, and the budget is enforced.

<br>



## Tech Stack

- Swift · SwiftUI
- SwiftData for local persistence
- FSCalendar (SPM) for daily and weekly progress visualization
- UserNotifications for the streak warning
- MVVM architecture
