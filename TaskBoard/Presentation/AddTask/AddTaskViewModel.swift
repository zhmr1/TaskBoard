// Created by Zhanibek Maratov

import Foundation

final class AddTaskViewModel {

    let boardId: UUID
    let status: TaskStatus
    private let useCase: TaskUseCase

    init(boardId: UUID, status: TaskStatus, useCase: TaskUseCase) {
        self.boardId = boardId
        self.status = status
        self.useCase = useCase
    }

    func createTask(title: String, description: String, priority: TaskPriority) -> TaskItem? {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        let task = TaskItem(
            boardId: boardId,
            title: title,
            taskDescription: description,
            status: status,
            priority: priority
        )
        return useCase.createTask(task)
    }
}
