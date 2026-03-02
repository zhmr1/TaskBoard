// Created by Zhanibek Maratov

import CoreData

final class BoardRepository: BoardRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() -> [Board] {
        let request = NSFetchRequest<BoardEntity>(entityName: "BoardEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toDomain() }
        } catch {
            return []
        }
    }

    @discardableResult
    func create(name: String) -> Board {
        let entity = BoardEntity(context: context)
        entity.id = UUID()
        entity.name = name
        entity.createdAt = Date()

        saveContext()
        return entity.toDomain()
    }

    func delete(id: UUID) {
        let request = NSFetchRequest<BoardEntity>(entityName: "BoardEntity")
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
