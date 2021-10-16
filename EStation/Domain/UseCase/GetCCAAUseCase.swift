//
//  GetCCAAUseCase.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine

protocol GetCCAAUseCaseType {
    func execute() -> AnyPublisher<[DomainCCAA], Error>
}

struct GetCCAAUseCase: GetCCAAUseCaseType {
    private let gasStationsRepository: GasStationsRepositoryType
    
    init(gasStationsRepository: GasStationsRepositoryType = GasStationsRepository()) {
        self.gasStationsRepository = gasStationsRepository
    }
    
    func execute() -> AnyPublisher<[DomainCCAA], Error> {
        gasStationsRepository.getCCAA()
    }
}
