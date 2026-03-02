// Created by Zhanibek Maratov

import UIKit

final class BoardListViewController: UIViewController {

    let viewModel: BoardListViewModel

    var onBoardSelected: ((Board) -> Void)?
    var onCreateBoard: (() -> Void)?

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(BoardCell.self, forCellReuseIdentifier: BoardCell.reuseId)
        table.rowHeight = 64
        return table
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No boards yet.\nTap + to create one."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    init(viewModel: BoardListViewModel) {
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
        viewModel.loadBoards()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadBoards()
    }

    private func setupUI() {
        title = "Boards"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addBoardTapped)
        )

        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !self.viewModel.boards.isEmpty
        }
    }

    @objc private func addBoardTapped() {
        onCreateBoard?()
    }
}

// MARK: - UITableViewDataSource & Delegate

extension BoardListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.boards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BoardCell.reuseId, for: indexPath
        ) as? BoardCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.boards[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onBoardSelected?(viewModel.boards[indexPath.row])
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            viewModel.deleteBoard(at: indexPath.row)
        }
    }
}
