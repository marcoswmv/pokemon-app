//
//  Appearance.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit

struct Appearance {

    static let screenSize: CGSize = UIScreen.main.bounds.size

    static let buttonColor: UIColor = .systemBlue

    static let cornerRadius: CGFloat = 10.0
    static let borderWidth: CGFloat = 1.0

    static let imageSize: CGFloat = 180.0
    static let detailImageSize: CGFloat = 300.0

    static let nameLabelHeight: CGFloat = 24.0
    static let priceLabelHeight: CGFloat = 18.0

    static let contentSpacement: CGFloat = 16.0

    static let detailNameFontSize: CGFloat = 26.0
    static let nameFontSize: CGFloat = 22.0

    static let sectionHeaderHeight: CGFloat = 28.0

    static let descendingIcon: UIImage = UIImage(systemName: "arrow.down")!
    static let ascendingIcon: UIImage = UIImage(systemName: "arrow.up")!

    static let filledStar: UIImage = UIImage(systemName: "star.fill")!
    static let star: UIImage = UIImage(systemName: "star")!
}
