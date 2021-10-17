//
//  GasStationsAPIClient.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine

protocol GasStationsAPIClientType {
    func getProducts() -> AnyPublisher<[Product], Error>
    func getCCAA() -> AnyPublisher<[CCAA], Error>
    func getProvinces(idCCAA: String?) -> AnyPublisher<[Province], Error>
    func getGasStations(idProvince: String, idProduct: String) -> AnyPublisher<GasPrices, Error>
}

final class GasStationsAPIClient: BaseAPIClient {
    let session: URLSession
    let jsonDecoder: JSONDecoder
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
        self.jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
}

extension GasStationsAPIClient: GasStationsAPIClientType {
    //******************************************************************************************************************
    // PRODUCTS
    //******************************************************************************************************************
    
    func getProducts() -> AnyPublisher<[Product], Error> {
        execute(GasStationLocationEndpoint.getProducts)
    }
    
    //******************************************************************************************************************
    // COMUNIDAD AUTONOMA
    //******************************************************************************************************************
    
    func getCCAA() -> AnyPublisher<[CCAA], Error> {
        execute(GasStationLocationEndpoint.getCCAA)
    }
    
    //******************************************************************************************************************
    // PROVINCIAS
    //******************************************************************************************************************
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[Province], Error> {
        execute(GasStationLocationEndpoint.getProvinces(idCCAA: idCCAA))
    }
    
    //******************************************************************************************************************
    // GASOLINERAS
    //******************************************************************************************************************
    
    func getGasStations(idProvince: String, idProduct: String) -> AnyPublisher<GasPrices, Error> {
        execute(GasStationLocationEndpoint.getGasStations(idProvince: idProvince, idProduct: idProduct))
    }
    
}
