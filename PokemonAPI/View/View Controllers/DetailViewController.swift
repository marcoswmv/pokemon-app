//
//  DetailViewController.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {

    private let viewModel: DetailViewModel

    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        return tableView
    }()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
        viewModel.fetchPokemon()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(pictureImageView)
        view.addSubview(tableView)

        makeConstraints()
    }
    
    private func makeConstraints() {
        pictureImageView.snp.makeConstraints { make in
            make.size.equalTo(Appearance.detailImageSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100.0)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(pictureImageView.snp.bottom).offset(5.0)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }

    private func bindViewModel() {
        viewModel.pokemon.bind { pokemon in
            guard let pokemon = pokemon,
                  let imageUrlString = pokemon.sprites.other?.officialArtwork.frontDefault,
                  let imageUrl = URL(string: imageUrlString) else { return }

            DispatchQueue.main.async {
                self.title = pokemon.name.uppercased()
                self.pictureImageView.kf.setImage(with: imageUrl)
            }
        }

        viewModel.description.bind { desc in
            guard desc != nil else { return }
            self.reloadTableView()
        }

        viewModel.error.bind { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.showAlert(with: error.localizedDescription)
            }
        }
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Description table view Data source and Delegate

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.description.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let descriptionArray = viewModel.description.value else { return nil }

        let contentView = UIView()
        contentView.backgroundColor = .systemGray6

        let headerLabel = UILabel()
        headerLabel.frame = CGRect(origin: .zero,
                                   size: CGSize(width: Appearance.screenSize.width,
                                                height: Appearance.sectionHeaderHeight))
        headerLabel.textAlignment = .center
        headerLabel.textColor = .gray
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.text = descriptionArray[section].0

        contentView.addSubview(headerLabel)

        return contentView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let descriptionArray = viewModel.description.value else { return 0 }
        return descriptionArray[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier) else {
            return UITableViewCell()
        }

        if let descriptionArray = viewModel.description.value {
            let text = descriptionArray[indexPath.section].1[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = text
        }
        
        return cell
    }
}
