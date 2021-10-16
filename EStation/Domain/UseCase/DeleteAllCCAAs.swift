//
//  DeleteAllCCAAs.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine

protocol DeleteAllCCAAsType {
    func execute() -> AnyPublisher<Int, Error>
}

struct DeleteAllCCAAs: DeleteAllCCAAsType {
    private let gasStationsRepository: GasStationsRepositoryType
    
    init(gasStationsRepository: GasStationsRepositoryType = GasStationsRepository()) {
        self.gasStationsRepository = gasStationsRepository
    }
    
    func execute() -> AnyPublisher<Int, Error> {
        gasStationsRepository.deleteAllCCAAs()
    }
}
