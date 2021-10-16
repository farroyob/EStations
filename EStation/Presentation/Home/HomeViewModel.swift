//
//  HomeViewModel.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var selectedCCAA: DomainCCAA?
    @Published var selectedProvince: DomainProvince?
    @Published var selectedProduct: DomainProduct?
    @Published var selectedGo: DomainGasStation?
}
