// Created by Zhanibek Maratov

import Foundation

protocol BoardUseCase {
    func getBoards() -> [Board]
    func createBoard(name: String) -> Board
    func deleteBoard(id: UUID)
}

final class BoardUseCaseImpl: BoardUseCase {

    private let repository: BoardRepositoryProtocol

    init(repository: BoardRepositoryProtocol) {
        self.repository = repository
    }

    func getBoards() -> [Board] {
        repository.fetchAll()
    }

    func createBoard(name: String) -> Board {
        repository.create(name: name)
    }

    func deleteBoard(id: UUID) {
        repository.delete(id: id)
    }
}
