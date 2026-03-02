// Created by Zhanibek Maratov

import CoreData

@objc(BoardEntity)
final class BoardEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var createdAt: Date

    func toDomain() -> Board {
        Board(id: id, name: name, createdAt: createdAt)
    }
}

@objc(TaskEntity)
final class TaskEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var boardId: UUID
    @NSManaged var title: String
    @NSManaged var taskDescription: String?
    @NSManaged var status: String
    @NSManaged var priority: String
    @NSManaged var createdAt: Date

    func toDomain() -> TaskItem {
        TaskItem(
            id: id,
            boardId: boardId,
            title: title,
            taskDescription: taskDescription ?? "",
            status: TaskStatus(rawValue: status) ?? .todo,
            priority: TaskPriority(rawValue: priority) ?? .medium,
            createdAt: createdAt
        )
    }
}
