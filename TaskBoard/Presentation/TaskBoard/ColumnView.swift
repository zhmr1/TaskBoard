// Created by Zhanibek Maratov

import UIKit

final class ColumnView: UIView {

    let status: TaskStatus
    var onAddTapped: (() -> Void)?
    var onMoveTapped: ((TaskItem, TaskStatus) -> Void)?
    var onDeleteTapped: ((TaskItem) -> Void)?

    private var tasks: [TaskItem] = []

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        return label
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()

    private lazy var headerStack: UIStackView = {
        let left = UIStackView(arrangedSubviews: [headerLabel, countLabel])
        left.axis = .horizontal
        left.spacing = 8

        let stack = UIStackView(arrangedSubviews: [left, addButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var cardsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStack, cardsStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    init(status: TaskStatus) {
        self.status = status
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12

        headerLabel.text = status.rawValue

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    func update(with tasks: [TaskItem]) {
        self.tasks = tasks
        countLabel.text = "\(tasks.count)"

        cardsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for task in tasks {
            let card = TaskCardView(task: task)

            card.onMove = { [weak self] newStatus in
                self?.onMoveTapped?(task, newStatus)
            }

            card.onDelete = { [weak self] in
                self?.onDeleteTapped?(task)
            }

            cardsStack.addArrangedSubview(card)
        }
    }

    @objc private func addTapped() {
        onAddTapped?()
    }
}
