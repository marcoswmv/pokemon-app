//
//  UITableViewCell+Extension.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
