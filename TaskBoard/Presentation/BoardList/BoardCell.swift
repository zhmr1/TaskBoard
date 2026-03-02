// Created by Zhanibek Maratov

import UIKit

final class BoardCell: UITableViewCell {

    static let reuseId = "BoardCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "rectangle.split.3x1")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let textStack = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let mainStack = UIStackView(arrangedSubviews: [iconView, textStack])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        return mainStack
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        accessoryType = .disclosureIndicator
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(with board: Board) {
        nameLabel.text = board.name
        dateLabel.text = Self.dateFormatter.string(from: board.createdAt)
    }
}
