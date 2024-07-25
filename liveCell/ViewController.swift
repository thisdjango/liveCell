//
//  ViewController.swift
//  liveCell
//
//  Created by Diana Tsarkova on 22.07.2024.
//

import UIKit

class ViewController: UIViewController {

    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let createButton = UIButton(type: .system)

    private let viewModel = ViewModel()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layout()
    }

    private func setup() {
        setupGradientLayer()
        setupTitleLabel()
        setupTableView()
        setupCreateButton()
        viewModel.updateHandler = { [weak self] in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, animations: {
                    self?.tableView.reloadData()
                }, completion: {_ in 
                    self?.tableView.scrollToRow(at: IndexPath(row: (self?.viewModel.cells.count ?? 1) - 1, section: 0), at: .bottom, animated: true)
                })
            }
        }
    }

    private func setupGradientLayer() {
        view.addGradient(colors: (UIColor(rgb: 0x310050).cgColor, UIColor.black.cgColor))
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.text = "Клеточное наполнение"
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 76
        tableView.rowHeight = 76
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    }

    private func setupCreateButton() {
        view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.backgroundColor = UIColor(rgb: 0x5A3472)
        createButton.setTitle("Сотворить".uppercased(), for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.clipsToBounds = false
        createButton.layer.cornerRadius = 4
        createButton.addTarget(self, action: #selector(addCell), for: .touchUpInside)
    }

    private func layout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 36),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc
    func addCell() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.viewModel.addCell()
        }
    }
}

typealias TableViewDelegate = UITableViewDelegate & UITableViewDataSource
extension ViewController: TableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        guard let cellType = viewModel.cells[safe: indexPath.row] else {
            return cell
        }
        cell.configure(cellType: cellType)
        return cell
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
