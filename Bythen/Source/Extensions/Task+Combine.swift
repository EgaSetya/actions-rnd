//
//  Task+Combine.swift
//  Bythen
//
//  Created by Darindra R on 10/10/24.
//

import Combine

public extension Task {
    func eraseToAnyCancellable() -> AnyCancellable {
        AnyCancellable(cancel)
    }

    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}
