// Created by Zhanibek Maratov

import UIKit

final class TaskBoardViewController: UIViewController {

    let viewModel: TaskBoardViewModel
    var onAddTask: ((TaskStatus) -> Void)?

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = false
        return scroll
    }()

    private lazy var columnsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
        return stack
    }()

    private var columnViews: [TaskStatus: ColumnView] = [:]

    init(viewModel: TaskBoardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadTasks()
    }

    private func setupUI() {
        title = viewModel.board.name
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(scrollView)
        scrollView.addSubview(columnsStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            columnsStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            columnsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            columnsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -12),
            columnsStack.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -12),
        ])

        for status in TaskStatus.allCases {
            let columnView = ColumnView(status: status)
            columnView.widthAnchor.constraint(equalToConstant: 280).isActive = true

            columnView.onAddTapped = { [weak self] in
                self?.onAddTask?(status)
            }

            columnView.onMoveTapped = { [weak self] task, newStatus in
                self?.viewModel.moveTask(task, to: newStatus)
            }

            columnView.onDeleteTapped = { [weak self] task in
                self?.viewModel.deleteTask(task)
            }

            columnsStack.addArrangedSubview(columnView)
            columnViews[status] = columnView
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            for status in TaskStatus.allCases {
                self.columnViews[status]?.update(with: self.viewModel.tasks(for: status))
            }
        }
    }
}
