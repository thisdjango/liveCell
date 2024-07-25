//
//  TableViewCell.swift
//  liveCell
//
//  Created by Diana Tsarkova on 23.07.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "\(TableViewCell.self)"

    private let iconSize = 40.0
    private let background = UIView()
    private let iconView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var model: CellType?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    func configure(cellType: CellType) {
        model = cellType
        let gradient = CAGradientLayer()
        gradient.colors = [cellType.colors.start, cellType.colors.end]
        gradient.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        gradient.locations = [0.0, 1.0]
        iconView.layer.addSublayer(gradient)
        iconLabel.text = cellType.model.icon
        titleLabel.text = cellType.model.title
        descriptionLabel.text = cellType.model.description
    }

    private func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        contentView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        background.clipsToBounds = false
        background.layer.cornerRadius = 8
        setupIcon()
        setupTitle()
        setupDescription()
    }

    private func setupIcon() {
        contentView.addSubview(iconView)
        contentView.addSubview(iconLabel)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.layer.masksToBounds = true
        iconView.layer.cornerRadius = iconSize / 2

        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.font = .systemFont(ofSize: 20)
        iconLabel.textAlignment = .center
    }

    private func setupTitle() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
    }

    private func setupDescription() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
        descriptionLabel.textColor = .black
    }

    private func layout() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            iconView.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize),
            iconView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            iconLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            iconLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor),
            iconLabel.trailingAnchor.constraint(equalTo: iconView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addGradient(colors: (start: CGColor, end: CGColor)) {
        let gradient = CAGradientLayer()
        gradient.colors = [colors.start, colors.end]
        gradient.frame = bounds
        gradient.locations = [0.0, 1.0]
        layer.addSublayer(gradient)
    }
}

extension CellType {
    var colors: (start: CGColor, end: CGColor) {
        switch self {
        case .dead:
            return (UIColor(rgb: 0x0D658A).cgColor, UIColor(rgb: 0xB0FFB4).cgColor)
        case .alive:
            return (UIColor(rgb: 0xFFB800).cgColor, UIColor(rgb: 0xFFF7B0).cgColor)
        case .life:
            return (UIColor(rgb: 0xAD00FF).cgColor, UIColor(rgb: 0xFFB0E9).cgColor)
        }
    }
}
