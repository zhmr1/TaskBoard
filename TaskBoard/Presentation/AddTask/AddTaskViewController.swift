// Created by Zhanibek Maratov

import UIKit

final class AddTaskViewController: UIViewController {

    private let viewModel: AddTaskViewModel
    var onTaskCreated: (() -> Void)?

    private lazy var titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Task title"
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)
        return field
    }()

    private lazy var descriptionView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 15)
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        return view
    }()

    private lazy var prioritySegment: UISegmentedControl = {
        let control = UISegmentedControl(items: TaskPriority.allCases.map(\.rawValue))
        control.selectedSegmentIndex = 1 // Medium
        return control
    }()

    private lazy var stackView: UIStackView = {
        let titleLabel = makeLabel("Title")
        let descLabel = makeLabel("Description")
        let priorityLabel = makeLabel("Priority")

        let stack = UIStackView(arrangedSubviews: [
            titleLabel, titleField,
            descLabel, descriptionView,
            priorityLabel, prioritySegment
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    init(viewModel: AddTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "New Task"
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(saveTapped)
        )

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionView.heightAnchor.constraint(equalToConstant: 100),
        ])

        titleField.becomeFirstResponder()
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        let priority = TaskPriority.allCases[prioritySegment.selectedSegmentIndex]
        let result = viewModel.createTask(
            title: titleField.text ?? "",
            description: descriptionView.text ?? "",
            priority: priority
        )

        if result != nil {
            onTaskCreated?()
            dismiss(animated: true)
        } else {
            titleField.layer.borderColor = UIColor.systemRed.cgColor
            titleField.layer.borderWidth = 1
        }
    }
}
