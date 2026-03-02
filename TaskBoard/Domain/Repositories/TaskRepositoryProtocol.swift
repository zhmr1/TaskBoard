// Created by Zhanibek Maratov

import Foundation

protocol TaskRepositoryProtocol {
    func fetchTasks(for boardId: UUID) -> [TaskItem]
    func create(task: TaskItem) -> TaskItem
    func update(task: TaskItem)
    func delete(id: UUID)
}
