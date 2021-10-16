//
//  Thread+Extensions.swift
//  EStation
//
//  Created by Freddy A. on 10/10/21.
//

import Foundation

extension Thread {
    func set(name: String) {
        pthread_setname_np(name)
    }
}
