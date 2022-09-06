//
//  PokemonTableViewCell.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!

//    var downloadTask: Do

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    static func nib() -> UINib {
        UINib(nibName: self.identifier, bundle: nil)
    }

    func fill(with viewModel: PokemonCellViewModel) {
//        downloadTask = downloadImage(from: viewModel.imageUrl) { [weak self] result in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let image):
//                    self.loaderView.stopAnimating()
//                    self.pictureImageView.image = image
//                case .failure:
//                    break
//                }
//            }
//        }

        pokemonNameLabel.text = viewModel.name.uppercased()
        pokemonNameLabel.sizeToFit()
    }
}
