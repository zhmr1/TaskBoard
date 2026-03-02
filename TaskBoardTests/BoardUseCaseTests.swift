// Created by Zhanibek Maratov

import XCTest
@testable import TaskBoard

final class MockBoardRepository: BoardRepositoryProtocol {

    var boards: [Board] = []

    func fetchAll() -> [Board] {
        boards
    }

    func create(name: String) -> Board {
        let board = Board(name: name)
        boards.append(board)
        return board
    }

    func delete(id: UUID) {
        boards.removeAll { $0.id == id }
    }
}

final class BoardUseCaseTests: XCTestCase {

    private var sut: BoardUseCaseImpl!
    private var mockRepo: MockBoardRepository!

    override func setUp() {
        super.setUp()
        mockRepo = MockBoardRepository()
        sut = BoardUseCaseImpl(repository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    func testGetBoards_empty() {
        XCTAssertTrue(sut.getBoards().isEmpty)
    }

    func testCreateBoard() {
        let board = sut.createBoard(name: "Sprint 1")
        XCTAssertEqual(board.name, "Sprint 1")
        XCTAssertEqual(sut.getBoards().count, 1)
    }

    func testDeleteBoard() {
        let board = sut.createBoard(name: "To Delete")
        XCTAssertEqual(sut.getBoards().count, 1)

        sut.deleteBoard(id: board.id)
        XCTAssertTrue(sut.getBoards().isEmpty)
    }

    func testMultipleBoards() {
        _ = sut.createBoard(name: "Board 1")
        _ = sut.createBoard(name: "Board 2")
        _ = sut.createBoard(name: "Board 3")

        XCTAssertEqual(sut.getBoards().count, 3)
    }
}
