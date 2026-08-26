# YearDotsCountdown

> A minimalist, interactive year-progress visualizer built with **SwiftUI** and **SwiftData**.

---

## About the Project

**YearDotsCountdown** transforms how you perceive time using a modern, declarative iOS interface. Each dot on the screen represents a day of the year, providing a visual map of past days, the current moment, and future **Milestones**.

---

## Key Features

* **Interactive Day Grid:** Visual representation of all 365 (or 366) days with automatic leap-year handling.
* **Smart Visual Priority:**
  * 🔵 **Past Days:** Completed days.
  * 🟢 **Today (Standard):** Pulsing green indicator for the current date.
  * 🔴 **Today with Milestone:** Fast-pulsing red indicator prioritizing active events for today.
  * 🟣 **Milestones:** Interactive purple dots for scheduled events.
* **Year Navigation (Time Travel):** Browse past and future years with dynamic grid and countdown recalculations.
* **Milestone Management:** Create, edit, and delete events with custom titles and dates.
* **Real-Time Countdown:** Live timers tracking time remaining until the next year or the selected milestone.
* **Local Notifications:** Automated reminders powered by the `UserNotifications` framework for upcoming milestones.
* **Persistent Storage:** Fully offline, local persistence using **SwiftData**.
* **Haptic Feedback:** Tactile responses integrated via `UIImpactFeedbackGenerator` and `UINotificationFeedbackGenerator`.
* **Automated Test Suite:** Comprehensive unit and UI test suites using the **XCTest** framework.

---

## Tech Stack

* **Language:** Swift 5 / Swift 6
* **UI Framework:** SwiftUI
* **Persistence:** SwiftData
* **Notifications:** UserNotifications Framework
* **Testing:** XCTest Framework (Unit & UI Tests)

---

## Project Structure

```text
YearDotsCountdown/
├── YearDotsCountdown/
│   ├── YearDotsCountdownApp.swift   # Main entry point & SwiftData container setup
│   ├── ContentView.swift            # Main view, interactive dot grid, and controls
│   ├── AddMilestoneView.swift       # Event creation/editing form and notification triggers
│   ├── LifeMilestone.swift          # SwiftData persistent model (@Model)
│   └── Assets.xcassets              # App icons, colors, and assets
├── YearDotsCountdownTests/
│   └── YearDotsCountdownTests.swift # Unit tests for date calculations and core logic
└── YearDotsCountdownUITests/
    └── YearDotsCountdownUITests.swift # End-to-end UI automation tests

## Getting Started

Follow these steps to set up the project locally on your machine for development and testing.

### Prerequisites

Ensure you have the following software installed:

* **macOS:** macOS Sonoma (version 14.0) or later
* **Xcode:** Xcode 15.0 or later (includes the Swift 5.9+ compiler and iOS 17 SDK)
* **iOS Simulator / Device:** iOS 17.0+ for running the application

---

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/YearDotsCountdown.git](https://github.com/YOUR_USERNAME/YearDotsCountdown.git)
   cd YearDotsCountdown
