//
//  PokemonsListViewController.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: Properties
    private let viewModel: ListViewModel = ListViewModel()
    private var sortUp: Bool = false

    // MARK: UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetch(for: 0)
    }

    private func setupUI() {
        title = Text.listTitleLabel.uppercased()

        let sortButton = UIBarButtonItem(title: Text.sortButtonTitle, style: .plain, target: self, action: #selector(handleSorting))
        self.navigationItem.rightBarButtonItem = sortButton

        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.frame = CGRect(x: 0.0,
                                 y: 0.0,
                                 width: Appearance.screenSize.width,
                                 height: Appearance.screenSize.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonTableViewCell.nib(), forCellReuseIdentifier: PokemonTableViewCell.identifier)
    }

    @objc func handleSorting() {
        sortUp.toggle()
        viewModel.items.value?.sort(by: { sortUp ? $0 < $1 : $0 > $1 })
        reloadTableView()
    }

    func bindViewModel() {
        viewModel.items.bind { _ in
            self.reloadTableView()
        }
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table View data source and delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Navigate to detail view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.identifier) as? PokemonTableViewCell else {
            return UITableViewCell()
        }

        if let viewModels = viewModel.items.value {
            cell.fill(with: viewModels[indexPath.row])
        }
        return cell
    }
}
