// Created by Zhanibek Maratov

import Foundation

enum TaskStatus: String, CaseIterable {
    case todo = "To Do"
    case inProgress = "In Progress"
    case done = "Done"
}

enum TaskPriority: String, CaseIterable, Comparable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        let order: [TaskPriority] = [.low, .medium, .high]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else { return false }
        return lhsIndex < rhsIndex
    }
}

struct TaskItem: Equatable {
    let id: UUID
    let boardId: UUID
    var title: String
    var taskDescription: String
    var status: TaskStatus
    var priority: TaskPriority
    let createdAt: Date

    init(
        id: UUID = UUID(),
        boardId: UUID,
        title: String,
        taskDescription: String = "",
        status: TaskStatus = .todo,
        priority: TaskPriority = .medium,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.boardId = boardId
        self.title = title
        self.taskDescription = taskDescription
        self.status = status
        self.priority = priority
        self.createdAt = createdAt
    }
}
