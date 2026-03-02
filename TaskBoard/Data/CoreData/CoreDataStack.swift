// Created by Zhanibek Maratov

import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var viewContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let model = Self.createManagedObjectModel()
        let container = NSPersistentContainer(name: "TaskBoard", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data failed to load: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    init() {}

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - Programmatic Model

    private static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // Board Entity
        let boardEntity = NSEntityDescription()
        boardEntity.name = "BoardEntity"
        boardEntity.managedObjectClassName = NSStringFromClass(BoardEntity.self)

        let boardId = NSAttributeDescription()
        boardId.name = "id"
        boardId.attributeType = .UUIDAttributeType
        boardId.isOptional = false

        let boardName = NSAttributeDescription()
        boardName.name = "name"
        boardName.attributeType = .stringAttributeType
        boardName.isOptional = false

        let boardCreatedAt = NSAttributeDescription()
        boardCreatedAt.name = "createdAt"
        boardCreatedAt.attributeType = .dateAttributeType
        boardCreatedAt.isOptional = false

        boardEntity.properties = [boardId, boardName, boardCreatedAt]

        // Task Entity
        let taskEntity = NSEntityDescription()
        taskEntity.name = "TaskEntity"
        taskEntity.managedObjectClassName = NSStringFromClass(TaskEntity.self)

        let taskId = NSAttributeDescription()
        taskId.name = "id"
        taskId.attributeType = .UUIDAttributeType
        taskId.isOptional = false

        let taskBoardId = NSAttributeDescription()
        taskBoardId.name = "boardId"
        taskBoardId.attributeType = .UUIDAttributeType
        taskBoardId.isOptional = false

        let taskTitle = NSAttributeDescription()
        taskTitle.name = "title"
        taskTitle.attributeType = .stringAttributeType
        taskTitle.isOptional = false

        let taskDesc = NSAttributeDescription()
        taskDesc.name = "taskDescription"
        taskDesc.attributeType = .stringAttributeType
        taskDesc.isOptional = true

        let taskStatus = NSAttributeDescription()
        taskStatus.name = "status"
        taskStatus.attributeType = .stringAttributeType
        taskStatus.isOptional = false

        let taskPriority = NSAttributeDescription()
        taskPriority.name = "priority"
        taskPriority.attributeType = .stringAttributeType
        taskPriority.isOptional = false

        let taskCreatedAt = NSAttributeDescription()
        taskCreatedAt.name = "createdAt"
        taskCreatedAt.attributeType = .dateAttributeType
        taskCreatedAt.isOptional = false

        taskEntity.properties = [taskId, taskBoardId, taskTitle, taskDesc, taskStatus, taskPriority, taskCreatedAt]

        model.entities = [boardEntity, taskEntity]
        return model
    }
}
