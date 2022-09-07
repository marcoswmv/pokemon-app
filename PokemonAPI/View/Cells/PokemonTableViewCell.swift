//
//  PokemonTableViewCell.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import UIKit
import Kingfisher
import SnapKit

class PokemonTableViewCell: UITableViewCell {

    var downloadTask: DownloadTask?

    private lazy var innerContentView: UIView = {
        UIView()
    }()

    private lazy var loaderView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()

    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Appearance.cornerRadius
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: Appearance.nameFontSize)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        downloadTask?.cancel()
        pictureImageView.image = nil
    }

    private func setupUI() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        innerContentView.subviews.forEach { $0.removeFromSuperview() }
        innerContentView.removeFromSuperview()

        contentView.addSubview(innerContentView)
        innerContentView.addSubview(pictureImageView)
        innerContentView.addSubview(nameLabel)

        pictureImageView.addSubview(loaderView)
    }

    private func makeConstraints() {
        innerContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pictureImageView.snp.makeConstraints { make in
            make.size.equalTo(Appearance.imageSize)
            make.leading.top.equalToSuperview().offset(Appearance.contentSpacement)
            make.trailing.equalTo(nameLabel.snp.leading).offset(-Appearance.contentSpacement)
            make.bottom.equalToSuperview().offset(-Appearance.contentSpacement)
        }

        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Appearance.contentSpacement)
        }

        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension PokemonTableViewCell {
    func fill(with viewModel: PokemonCellViewModel) {
        loaderView.startAnimating()
        downloadTask = pictureImageView.kf.setImage(with: viewModel.imageUrl, options: [.fromMemoryCacheOrRefresh], completionHandler: { _ in
            self.loaderView.stopAnimating()
        })
        nameLabel.text = viewModel.name.uppercased()
        nameLabel.sizeToFit()
    }
}
