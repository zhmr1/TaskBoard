// Created by Zhanibek Maratov

import Foundation

final class TaskBoardViewModel {

    let board: Board
    private let useCase: TaskUseCase

    private(set) var todoTasks: [TaskItem] = []
    private(set) var inProgressTasks: [TaskItem] = []
    private(set) var doneTasks: [TaskItem] = []

    var onUpdate: (() -> Void)?

    init(board: Board, useCase: TaskUseCase) {
        self.board = board
        self.useCase = useCase
    }

    func loadTasks() {
        let all = useCase.getTasks(for: board.id)
        todoTasks = all.filter { $0.status == .todo }.sorted { $0.priority > $1.priority }
        inProgressTasks = all.filter { $0.status == .inProgress }.sorted { $0.priority > $1.priority }
        doneTasks = all.filter { $0.status == .done }.sorted { $0.priority > $1.priority }
        onUpdate?()
    }

    func moveTask(_ task: TaskItem, to status: TaskStatus) {
        useCase.moveTask(task, to: status)
        loadTasks()
    }

    func deleteTask(_ task: TaskItem) {
        useCase.deleteTask(id: task.id)
        loadTasks()
    }

    func tasks(for status: TaskStatus) -> [TaskItem] {
        switch status {
        case .todo: return todoTasks
        case .inProgress: return inProgressTasks
        case .done: return doneTasks
        }
    }
}
