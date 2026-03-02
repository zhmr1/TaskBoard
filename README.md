# TaskBoard

A Kanban-style task management app built with UIKit (programmatic UI), Clean Architecture, and Core Data.

## Features

- **Multiple Boards** — Create, view, and delete task boards
- **Kanban Columns** — Tasks organized in "To Do", "In Progress", and "Done" columns
- **Task Management** — Create tasks with title, description, and priority level (Low/Medium/High)
- **Move Tasks** — Move tasks between columns via context menu
- **Priority Sorting** — Tasks sorted by priority within each column
- **Swipe to Delete** — Remove boards and tasks with swipe gestures
- **Persistent Storage** — All data persisted locally with Core Data

## Architecture

**Clean Architecture** with Coordinator pattern for navigation.

```
TaskBoard/
├── App/                          # AppDelegate, SceneDelegate, AppCoordinator
├── Domain/
│   ├── Entities/                 # Board, TaskItem, TaskStatus, TaskPriority
│   ├── UseCases/                 # BoardUseCase, TaskUseCase
│   └── Repositories/            # Repository protocols
├── Data/
│   ├── CoreData/                 # CoreDataStack (programmatic model), ManagedObjects
│   └── Repositories/            # Repository implementations
├── Presentation/
│   ├── BoardList/                # Board list screen (VC, VM, Cell)
│   ├── TaskBoard/                # Kanban board screen (VC, VM, ColumnView, TaskCardView)
│   └── AddTask/                  # Add task screen (VC, VM)
└── Extensions/
```

### Key Architecture Decisions

- **Programmatic Core Data model** — No `.xcdatamodeld` file; the NSManagedObjectModel is built entirely in code, making it easier to version and review in PRs
- **Coordinator pattern** — Navigation logic separated from view controllers
- **Protocol-based DI** — All dependencies injected via protocols for testability
- **Domain-driven layers** — Domain layer has zero framework dependencies (no UIKit/CoreData imports)

## Tech Stack

- **UI:** UIKit (100% programmatic, no storyboards)
- **Architecture:** Clean Architecture + MVVM + Coordinator
- **Persistence:** Core Data (programmatic model)
- **Navigation:** Coordinator pattern
- **Testing:** XCTest with mock repositories
- **Minimum Target:** iOS 16.0

## Getting Started

1. Clone the repository
2. Open `TaskBoard.xcodeproj` in Xcode 15+
3. Build and run on a simulator or device (iOS 16+)

## Tests

Unit tests cover:
- `BoardUseCase` — CRUD operations for boards
- `TaskUseCase` — create, move, update, delete tasks; board filtering

Run tests with `Cmd + U` in Xcode.

## Screenshots

*Coming soon*

## License

MIT
