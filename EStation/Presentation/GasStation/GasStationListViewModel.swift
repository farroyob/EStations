//
//  GasStationListViewModel.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine

class GasStationListViewModel: ObservableObject {
    private let getGasStations: GetGasStationsType
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var elements: [DomainGasStation] = []
    
    init(getGasStations: GetGasStationsType = GetGasStations()) {
        self.getGasStations = getGasStations
    }
    
    func getGasStations(idProvince: String, idProduct: String) {
        self.getGasStations.execute(idProvince: idProvince, idProduct: idProduct)
            .sink(receiveCompletion: { _ in }) { [weak self] allGasStations in
                guard let self = self else { return }
                self.elements = allGasStations.sorted()
            }
            .store(in: &cancellables)
    }
}
