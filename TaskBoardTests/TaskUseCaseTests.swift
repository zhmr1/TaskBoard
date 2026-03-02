// Created by Zhanibek Maratov

import XCTest
@testable import TaskBoard

final class MockTaskRepository: TaskRepositoryProtocol {

    var tasks: [TaskItem] = []

    func fetchTasks(for boardId: UUID) -> [TaskItem] {
        tasks.filter { $0.boardId == boardId }
    }

    func create(task: TaskItem) -> TaskItem {
        tasks.append(task)
        return task
    }

    func update(task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }

    func delete(id: UUID) {
        tasks.removeAll { $0.id == id }
    }
}

final class TaskUseCaseTests: XCTestCase {

    private var sut: TaskUseCaseImpl!
    private var mockRepo: MockTaskRepository!
    private let boardId = UUID()

    override func setUp() {
        super.setUp()
        mockRepo = MockTaskRepository()
        sut = TaskUseCaseImpl(repository: mockRepo)
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil
        super.tearDown()
    }

    func testCreateTask() {
        let task = TaskItem(boardId: boardId, title: "Test Task")
        let created = sut.createTask(task)

        XCTAssertEqual(created.title, "Test Task")
        XCTAssertEqual(sut.getTasks(for: boardId).count, 1)
    }

    func testMoveTask() {
        let task = TaskItem(boardId: boardId, title: "Move Me", status: .todo)
        _ = sut.createTask(task)

        sut.moveTask(task, to: .inProgress)

        let updated = sut.getTasks(for: boardId).first
        XCTAssertEqual(updated?.status, .inProgress)
    }

    func testDeleteTask() {
        let task = TaskItem(boardId: boardId, title: "Delete Me")
        _ = sut.createTask(task)
        XCTAssertEqual(sut.getTasks(for: boardId).count, 1)

        sut.deleteTask(id: task.id)
        XCTAssertTrue(sut.getTasks(for: boardId).isEmpty)
    }

    func testTasksFilteredByBoard() {
        let otherBoardId = UUID()
        _ = sut.createTask(TaskItem(boardId: boardId, title: "Task 1"))
        _ = sut.createTask(TaskItem(boardId: boardId, title: "Task 2"))
        _ = sut.createTask(TaskItem(boardId: otherBoardId, title: "Other Task"))

        XCTAssertEqual(sut.getTasks(for: boardId).count, 2)
        XCTAssertEqual(sut.getTasks(for: otherBoardId).count, 1)
    }

    func testUpdateTask() {
        var task = TaskItem(boardId: boardId, title: "Original")
        _ = sut.createTask(task)

        task.title = "Updated"
        task.priority = .high
        sut.updateTask(task)

        let updated = sut.getTasks(for: boardId).first
        XCTAssertEqual(updated?.title, "Updated")
        XCTAssertEqual(updated?.priority, .high)
    }
}
