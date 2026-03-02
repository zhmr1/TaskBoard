// Created by Zhanibek Maratov

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

final class AppCoordinator: Coordinator {

    let navigationController: UINavigationController

    private let coreDataStack: CoreDataStack
    private let boardRepository: BoardRepositoryProtocol
    private let taskRepository: TaskRepositoryProtocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coreDataStack = CoreDataStack()
        self.boardRepository = BoardRepository(context: coreDataStack.viewContext)
        self.taskRepository = TaskRepository(context: coreDataStack.viewContext)
    }

    func start() {
        showBoardList()
    }

    private func showBoardList() {
        let useCase = BoardUseCaseImpl(repository: boardRepository)
        let viewModel = BoardListViewModel(useCase: useCase)
        let viewController = BoardListViewController(viewModel: viewModel)

        viewController.onBoardSelected = { [weak self] board in
            self?.showTaskBoard(for: board)
        }

        viewController.onCreateBoard = { [weak self] in
            self?.showCreateBoard(from: viewController)
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    func showTaskBoard(for board: Board) {
        let useCase = TaskUseCaseImpl(repository: taskRepository)
        let viewModel = TaskBoardViewModel(board: board, useCase: useCase)
        let viewController = TaskBoardViewController(viewModel: viewModel)

        viewController.onAddTask = { [weak self] status in
            self?.showAddTask(for: board, status: status, from: viewController)
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    private func showCreateBoard(from presenter: UIViewController) {
        let alert = UIAlertController(title: "New Board", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Board name"
        }

        let create = UIAlertAction(title: "Create", style: .default) { [weak presenter] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            if let vc = presenter as? BoardListViewController {
                vc.viewModel.createBoard(name: name)
            }
        }

        alert.addAction(create)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        presenter.present(alert, animated: true)
    }

    private func showAddTask(
        for board: Board,
        status: TaskStatus,
        from presenter: UIViewController
    ) {
        let useCase = TaskUseCaseImpl(repository: taskRepository)
        let viewModel = AddTaskViewModel(boardId: board.id, status: status, useCase: useCase)
        let viewController = AddTaskViewController(viewModel: viewModel)

        viewController.onTaskCreated = {
            if let taskBoardVC = presenter as? TaskBoardViewController {
                taskBoardVC.viewModel.loadTasks()
            }
        }

        let nav = UINavigationController(rootViewController: viewController)
        presenter.present(nav, animated: true)
    }
}
