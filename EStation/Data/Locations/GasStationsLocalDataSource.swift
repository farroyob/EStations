//
//  GasStationsLocalDataSource.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation
import Combine

protocol GasStationsLocalDataSourceType {
    func getCCAA() -> AnyPublisher<[CCAA], Error>
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error>
    func deleteAllCCAAs() -> AnyPublisher<Int, Error>
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[Province], Error>
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error>
    func deleteAllProvinces() -> AnyPublisher<Int, Error>
    
    func productGet() -> AnyPublisher<[Product], Error>
    func productSave(list: [Product]) -> AnyPublisher<[Product], Error>
    func productDeleteAll() -> AnyPublisher<Int, Error>
     
    func goGet(idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error>
    func goSave(list: [GasStation], idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error>
    func goDelete(idProvince: String, idProduct: String) -> AnyPublisher<Int, Error>
    func goDeleteAll() -> AnyPublisher<Int, Error>
}

struct GasStationsLocalDataSource {
    private let persistenceController: PersistenceControllerType
    
    init(persistenceController: PersistenceControllerType = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
}

extension GasStationsLocalDataSource: GasStationsLocalDataSourceType {
    func getCCAA() -> AnyPublisher<[CCAA], Error> {
        print("GasStationsLocalDataSource going to GET all CCAAs from local data source")
        return persistenceController.getCCAA()
    }
    
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error> {
        print("GasStationsLocalDataSource going to SAVE \(ccaaList.count) CCAAs")
        return persistenceController.save(ccaaList: ccaaList)
    }
    
    func deleteAllCCAAs() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL CCAAs")
        return persistenceController.deleteAllCCAAs()
    }
    
    
    
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[Province], Error> {
        print("GasStationsLocalDataSource going to GET PROVINCES from local data source")
        return persistenceController.getProvinces(idCCAA: idCCAA)
    }
    
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error> {
        print("GasStationsLocalDataSource going to persist \(provincesList.count) elements")
        return persistenceController.save(provincesList: provincesList)
    }
    
    func deleteAllProvinces() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL PROVINCES")
        return persistenceController.deleteAllProvinces()
    }
    
  
    
    func productGet() -> AnyPublisher<[Product], Error> {
        print("GasStationsLocalDataSource going to GET all Produtcs from local data source")
        return persistenceController.productGet()
    }
    
    func productSave(list: [Product]) -> AnyPublisher<[Product], Error> {
        print("GasStationsLocalDataSource going to SAVE \(list.count) CCAAs")
        return persistenceController.productSave(list: list)
    }
    
    func productDeleteAll() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL CCAAs")
        return persistenceController.productDeleteAll()
    }
    
    func goGet(idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error> {
        print("GasStationsLocalDataSource going to GET all GoS from local data source")
        return persistenceController.goGet(idProvince: idProvince, idProduct: idProduct)
    }
    
    func goSave(list: [GasStation], idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error> {
        print("GasStationsLocalDataSource going to SAVE \(list.count) GoS")
        return persistenceController.goSave(list: list, idProvince: idProvince, idProduct: idProduct)
    }
    
    func goDelete(idProvince: String, idProduct: String) -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE (Province & Product) GoS")
        return persistenceController.goDelete(idProvince: idProvince, idProduct: idProduct)
    }
    
    func goDeleteAll() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL GoS")
        return persistenceController.goDeleteAll()
    }
}

