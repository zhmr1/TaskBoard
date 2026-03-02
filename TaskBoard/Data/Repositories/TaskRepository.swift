// Created by Zhanibek Maratov

import CoreData

final class TaskRepository: TaskRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTasks(for boardId: UUID) -> [TaskItem] {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "boardId == %@", boardId as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]

        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toDomain() }
        } catch {
            return []
        }
    }

    @discardableResult
    func create(task: TaskItem) -> TaskItem {
        let entity = TaskEntity(context: context)
        entity.id = task.id
        entity.boardId = task.boardId
        entity.title = task.title
        entity.taskDescription = task.taskDescription
        entity.status = task.status.rawValue
        entity.priority = task.priority.rawValue
        entity.createdAt = task.createdAt

        saveContext()
        return entity.toDomain()
    }

    func update(task: TaskItem) {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            guard let entity = try context.fetch(request).first else { return }
            entity.title = task.title
            entity.taskDescription = task.taskDescription
            entity.status = task.status.rawValue
            entity.priority = task.priority.rawValue
            saveContext()
        } catch {
            // Handle silently
        }
    }

    func delete(id: UUID) {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            // Handle silently
        }
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
