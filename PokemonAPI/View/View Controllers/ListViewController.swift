//
//  PokemonsListViewController.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit

final class ListViewController: UIViewController {

    // MARK: Properties
    private let viewModel: ListViewModel = ListViewModel()

    // MARK: UI Elements
    private lazy var sortingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.sortButtonTitle, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setImage(Appearance.descendingIcon, for: .normal)
        button.sizeToFit()
        return button
    }()

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
        viewModel.fetchPokemonsList()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        title = Text.listTitleLabel.uppercased()

        setupNavigationBarButton()
        setupTableView()
    }

    private func setupNavigationBarButton() {
        sortingButton.addTarget(self, action: #selector(handleSorting), for: .touchUpInside)
        let sortButton = UIBarButtonItem(customView: sortingButton)
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
    }

    @objc private func handleSorting() {
        viewModel.sortList()
    }

    private func bindViewModel() {
        viewModel.items.bind { _ in
            self.reloadTableView()
        }

        viewModel.error.bind { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.showAlert(with: error.localizedDescription)
            }
        }

        viewModel.sorting.bind { sort in
            guard let sort = sort else { return }
            self.sortingButton.setImage(sort ? Appearance.ascendingIcon : Appearance.descendingIcon, for: .normal)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = (viewModel.items.value?.endIndex ?? 0) - 4
        if lastIndex >= 0, indexPath.row == lastIndex {
            viewModel.paginateList()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewModels = viewModel.items.value,
           let pokemonModel = viewModel.getModel(by: viewModels[indexPath.row].id) {
            let detailViewModel = DetailViewModel(pokemonId: pokemonModel.id)
            let detailViewController = DetailViewController(viewModel: detailViewModel)
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
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
