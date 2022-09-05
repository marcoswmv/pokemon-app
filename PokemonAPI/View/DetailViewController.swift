//
//  DetailViewController.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit

class DetailViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutViews()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(nameLabel)
        view.addSubview(pictureImageView)

        nameLabel.text = "Ditto"
        pictureImageView.image = UIImage(named: "ditto")
    }

    private func layoutViews() {
        pictureImageView.frame = CGRect(origin: .zero,
                                        size: CGSize(width: Appearance.screenSize.width - (Appearance.contentSpacement * 2),
                                                     height: Appearance.screenSize.height - (Appearance.contentSpacement * 2)))
        pictureImageView.center = view.center

        nameLabel.frame = CGRect(origin: .zero,
                                 size: CGSize(width: Appearance.screenSize.width - (Appearance.contentSpacement * 2),
                                              height: Appearance.nameLabelHeight))
        nameLabel.center = CGPoint(x: Appearance.screenSize.width / 2,
                                   y: Appearance.screenSize.height - (Appearance.screenSize.height * 0.85))
        nameLabel.sizeToFit()
    }
}

