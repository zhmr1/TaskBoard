// Created by Zhanibek Maratov

import Foundation

final class BoardListViewModel {

    private(set) var boards: [Board] = []
    private let useCase: BoardUseCase

    var onUpdate: (() -> Void)?

    init(useCase: BoardUseCase) {
        self.useCase = useCase
    }

    func loadBoards() {
        boards = useCase.getBoards()
        onUpdate?()
    }

    func createBoard(name: String) {
        _ = useCase.createBoard(name: name)
        loadBoards()
    }

    func deleteBoard(at index: Int) {
        guard index < boards.count else { return }
        useCase.deleteBoard(id: boards[index].id)
        loadBoards()
    }
}
