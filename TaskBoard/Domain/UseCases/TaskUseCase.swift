// Created by Zhanibek Maratov

import Foundation

protocol TaskUseCase {
    func getTasks(for boardId: UUID) -> [TaskItem]
    func createTask(_ task: TaskItem) -> TaskItem
    func updateTask(_ task: TaskItem)
    func deleteTask(id: UUID)
    func moveTask(_ task: TaskItem, to status: TaskStatus)
}

final class TaskUseCaseImpl: TaskUseCase {

    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol) {
        self.repository = repository
    }

    func getTasks(for boardId: UUID) -> [TaskItem] {
        repository.fetchTasks(for: boardId)
    }

    func createTask(_ task: TaskItem) -> TaskItem {
        repository.create(task: task)
    }

    func updateTask(_ task: TaskItem) {
        repository.update(task: task)
    }

    func deleteTask(id: UUID) {
        repository.delete(id: id)
    }

    func moveTask(_ task: TaskItem, to status: TaskStatus) {
        var updated = task
        updated.status = status
        repository.update(task: updated)
    }
}
