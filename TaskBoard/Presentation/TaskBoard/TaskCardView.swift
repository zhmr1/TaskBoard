// Created by Zhanibek Maratov

import UIKit

final class TaskCardView: UIView {

    var onMove: ((TaskStatus) -> Void)?
    var onDelete: (() -> Void)?

    private let task: TaskItem

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()

    private lazy var priorityBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()

    private lazy var moveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right.circle"), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = createMoveMenu()
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        return button
    }()

    init(task: TaskItem) {
        self.task = task
        super.init(frame: .zero)
        setupUI()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2

        let actionsStack = UIStackView(arrangedSubviews: [priorityBadge, UIView(), moveButton, deleteButton])
        actionsStack.axis = .horizontal
        actionsStack.spacing = 8
        actionsStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, actionsStack])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 6

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }

    private func configure() {
        titleLabel.text = task.title
        descriptionLabel.text = task.taskDescription
        descriptionLabel.isHidden = task.taskDescription.isEmpty

        priorityBadge.text = " \(task.priority.rawValue) "
        switch task.priority {
        case .high:
            priorityBadge.backgroundColor = .systemRed.withAlphaComponent(0.15)
            priorityBadge.textColor = .systemRed
        case .medium:
            priorityBadge.backgroundColor = .systemOrange.withAlphaComponent(0.15)
            priorityBadge.textColor = .systemOrange
        case .low:
            priorityBadge.backgroundColor = .systemGreen.withAlphaComponent(0.15)
            priorityBadge.textColor = .systemGreen
        }
    }

    private func createMoveMenu() -> UIMenu {
        let otherStatuses = TaskStatus.allCases.filter { $0 != task.status }
        let actions = otherStatuses.map { status in
            UIAction(title: "Move to \(status.rawValue)") { [weak self] _ in
                self?.onMove?(status)
            }
        }
        return UIMenu(title: "Move to...", children: actions)
    }

    @objc private func deleteTapped() {
        onDelete?()
    }
}
