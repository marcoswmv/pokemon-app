//
//  DetailViewController.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    private let viewModel: DetailViewModel

    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Appearance.detailNameFontSize)
        return label
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
        bindViewModel()
        viewModel.fetchPokemon()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(pictureImageView)

        makeConstraints()
    }

    private func makeConstraints() {
        pictureImageView.snp.makeConstraints { make in
            make.size.equalTo(Appearance.detailImageSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100.0)
        }
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

        viewModel.error.bind { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                self.showAlert(with: error.localizedDescription)
            }
        }
    }
}

