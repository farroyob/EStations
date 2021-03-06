//
//  GasStationsRepository.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine

protocol GasStationsRepositoryType {
    func getCCAA() -> AnyPublisher<[DomainCCAA], Error>
    func deleteAllCCAAs() -> AnyPublisher<Int, Error>
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[DomainProvince], Error>
    func deleteAllProvinces() -> AnyPublisher<Int, Error>
    
    func getProducts() -> AnyPublisher<[DomainProduct], Error>
    
    func getGasStations(idProvince: String,
                        idProduct: String) -> AnyPublisher<[DomainGasStation], Error>
}

struct GasStationsRepository {
    private let localDataSource: GasStationsLocalDataSourceType
    private let apiClient: GasStationsAPIClientType
    
    init(localDataSource: GasStationsLocalDataSourceType = GasStationsLocalDataSource(),
         apiClient: GasStationsAPIClientType = GasStationsAPIClient()) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }
}

extension GasStationsRepository: GasStationsRepositoryType {
    func getSimulatenous() -> AnyPublisher<[DomainCCAA], Error>  {
        let localCCAAs = localDataSource.getCCAA()
        let apiCCAAs = apiClient.getCCAA()
        
        let result = Publishers.Merge(localCCAAs, apiCCAAs)
            .compactMap { $0.map { DomainCCAA(ccaa: $0, dataProvinces: []) } }
            .eraseToAnyPublisher()
        
        return result
    }
    
    //******************************************************************************************************************
    // COMUNIDAD AUTONOMAS
    //******************************************************************************************************************
    
    func getCCAA() -> AnyPublisher<[DomainCCAA], Error> {
        let retrievedCCAAs = localDataSource.getCCAA()
        
        let checkedCCAAs = retrievedCCAAs
            .flatMap { allCCAAsArray -> AnyPublisher<[CCAA], Error> in
                print("GasStationsRepository we got \(allCCAAsArray.count) CCAAs from the local data source")
                // timestamp
                if allCCAAsArray.isEmpty {
                    print("GasStationsRepository going to fetch all CCAAs from the API")
                    return apiClient.getCCAA()
                        .flatMap {
                            return localDataSource.save(ccaaList: $0)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Future<[CCAA], Error>() { promise in
                        promise(.success(allCCAAsArray))
                    }
                    .eraseToAnyPublisher()
                }
            }
        
        let result = checkedCCAAs.compactMap { $0.map { DomainCCAA(ccaa: $0, dataProvinces: []) } }
            .eraseToAnyPublisher()
        
        return result
    }
    
    func deleteAllCCAAs() -> AnyPublisher<Int, Error> {
        localDataSource.deleteAllCCAAs()
    }
    
    //******************************************************************************************************************
    // PROVINCIAS
    //******************************************************************************************************************
    
    func deleteAllProvinces() -> AnyPublisher<Int, Error> {
        localDataSource.deleteAllProvinces()
    }
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[DomainProvince], Error> {
        let retrievedProvinces = localDataSource.getProvinces(idCCAA: idCCAA)
        
        let checkedProvinces = retrievedProvinces
            .flatMap { allProvincesArray -> AnyPublisher<[Province], Error> in
                print("GasStationsRepository we got \(allProvincesArray.count) provinces from the local data source")
                // timestamp
                if allProvincesArray.isEmpty {
                    print("GasStationsRepository going to fetch provinces from the API")
                    return apiClient.getProvinces(idCCAA: idCCAA)
                        .flatMap {
                            return localDataSource.save(provincesList: $0)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Future<[Province], Error>() { promise in
                        promise(.success(allProvincesArray))
                    }
                    .eraseToAnyPublisher()
                }
            }
        
        
        let result = checkedProvinces.compactMap { $0.map { DomainProvince(province: $0) } }
            .eraseToAnyPublisher()
        
        return result
    }
    
    //******************************************************************************************************************
    // PRODUCTOS
    //******************************************************************************************************************
    
    func getProducts() -> AnyPublisher<[DomainProduct], Error> {
        let retrieved = localDataSource.productGet()
        
        let checked = retrieved
            .flatMap { allEntitiesArray -> AnyPublisher<[Product], Error> in
                print("GasStationsRepository we got \(allEntitiesArray.count) Products from the local data source")
                // timestamp
                if allEntitiesArray.isEmpty {
                    print("GasStationsRepository going to fetch all Products from the API")
                    return apiClient.getProducts()
                        .flatMap {
                            return localDataSource.productSave(list: $0)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Future<[Product], Error>() { promise in
                        promise(.success(allEntitiesArray))
                    }
                    .eraseToAnyPublisher()
                }
            }
        
        print(checked)
        
        let result = checked.compactMap { $0.map { DomainProduct(product: $0) } }
            .eraseToAnyPublisher()
        
        return result
    }
    
    //******************************************************************************************************************
    // GASOLINERAS
    //******************************************************************************************************************
    
    func getGasStations(idProvince: String,
                        idProduct: String) -> AnyPublisher<[DomainGasStation], Error> {
        
        // Primero se borran los registros de la Provincia / Producto que tengan mas de 30 min
        let _ = localDataSource.goDelete(idProvince: idProvince, idProduct: idProduct)
        
        // Despues se verifica si existen datos locales vigentes
        let retrieved = localDataSource.goGet(idProvince: idProvince, idProduct: idProduct)
        
        let checked = retrieved
            .flatMap { allEntitiesArray -> AnyPublisher<[GasStation], Error> in
                print("GasStationsRepository we got \(allEntitiesArray.count) Products from the local data source")
                // timestamp
                if allEntitiesArray.isEmpty {
                    print("GasStationsRepository going to fetch all Products from the API")
                    return apiClient.getGasStations(idProvince: idProvince, idProduct: idProduct)
                        .flatMap {
                            return localDataSource.goSave(list: $0.elements, idProvince: idProvince, idProduct: idProduct, dateCall: $0.date)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Future<[GasStation], Error>() { promise in
                        promise(.success(allEntitiesArray))
                    }
                    .eraseToAnyPublisher()
                }
            }
        
        let result = checked.compactMap { $0.map { DomainGasStation(gasStation: $0) } }
            .eraseToAnyPublisher()
        
        return result
    }
}

