//
//  Observable.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import Foundation

final class Observable<T> {
    var value: T? {
        didSet {
            self.listener?(value)
        }
    }

    private var listener: ((T?) -> Void)?

    init(_ value: T?) {
        self.value = value
    }

    func bind(_ handler: ((T?) -> Void)?) {
        handler?(value)
        self.listener = handler
    }
}
