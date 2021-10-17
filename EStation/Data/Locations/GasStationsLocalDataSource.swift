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
    func goSave(list: [GasStation], idProvince: String, idProduct: String, dateCall: String) -> AnyPublisher<[GasStation], Error>
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
    //******************************************************************************************************************
    // COMUNIDAD AUTONOMA
    //******************************************************************************************************************
    
    func getCCAA() -> AnyPublisher<[CCAA], Error> {
        return persistenceController.getCCAA()
    }
    
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error> {
        return persistenceController.save(ccaaList: ccaaList)
    }
    
    func deleteAllCCAAs() -> AnyPublisher<Int, Error> {
        return persistenceController.deleteAllCCAAs()
    }
    
    //******************************************************************************************************************
    // PROVINCIAS
    //******************************************************************************************************************
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[Province], Error> {
        return persistenceController.getProvinces(idCCAA: idCCAA)
    }
    
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error> {
        return persistenceController.save(provincesList: provincesList)
    }
    
    func deleteAllProvinces() -> AnyPublisher<Int, Error> {
        return persistenceController.deleteAllProvinces()
    }
    
    //******************************************************************************************************************
    // PRODUCTOS
    //******************************************************************************************************************
    
    func productGet() -> AnyPublisher<[Product], Error> {
        return persistenceController.productGet()
    }
    
    func productSave(list: [Product]) -> AnyPublisher<[Product], Error> {
        return persistenceController.productSave(list: list)
    }
    
    func productDeleteAll() -> AnyPublisher<Int, Error> {
        return persistenceController.productDeleteAll()
    }
    
    //******************************************************************************************************************
    // GASOLINERAS
    //******************************************************************************************************************
    
    func goGet(idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error> {
        let dateInt: Int
        
        dateInt = getDateMinutesCurrent()
        
        print("GasStationsLocalDataSource going to GET all GoS from local data source")
        
        return persistenceController.goGet(idProvince: idProvince, idProduct: idProduct, dateInt: dateInt)
    }
    
    func goSave(list: [GasStation], idProvince: String, idProduct: String, dateCall: String) -> AnyPublisher<[GasStation], Error> {
        let dateInt: Int
        
        dateInt = getDateMinutes(dateString: dateCall)
        
        return persistenceController.goSave(list: list, idProvince: idProvince, idProduct: idProduct, dateInt: dateInt)
    }
    
    func goDelete(idProvince: String, idProduct: String) -> AnyPublisher<Int, Error> {
        let dateInt: Int
        
        dateInt = getDateMinutesCurrent()
        
        print("GasStationsLocalDataSource going to DELETE (Province & Product) GoS")
        return persistenceController.goDelete(idProvince: idProvince, idProduct: idProduct, dateInt: dateInt)
    }
    
    func goDeleteAll() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL GoS")
        return persistenceController.goDeleteAll()
    }
    
    //******************************************************************************************************************
    // FUNCIONES
    //******************************************************************************************************************
    
    func getDateMinutes(dateString: String) -> Int {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        var dateQuery: Date
        var year: Int
        var month: Int
        var day: Int
        var hour: Int
        var minutes: Int
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        if let date = dateFormatter.date(from:dateString) {
            dateQuery = date
        } else {
            dateQuery = Date()
        }
        
        year = calendar.component(.year, from: dateQuery)
        month = calendar.component(.month, from: dateQuery)
        day = calendar.component(.day, from: dateQuery)
        
        hour = calendar.component(.hour, from: dateQuery)
        minutes = calendar.component(.minute, from: dateQuery)
        
        return (year * 525600) + (month * 43800) + (day * 1440) + (hour * 60) + (minutes + 30)
    }
    
    func getDateMinutesCurrent() -> Int {
        let calendar = Calendar.current
        
        var dateQuery: Date
        var year: Int
        var month: Int
        var day: Int
        var hour: Int
        var minutes: Int
        
        dateQuery = Date()
        
        year = calendar.component(.year, from: dateQuery)
        month = calendar.component(.month, from: dateQuery)
        day = calendar.component(.day, from: dateQuery)
        
        hour = calendar.component(.hour, from: dateQuery)
        minutes = calendar.component(.minute, from: dateQuery)
        
        return (year * 525600) + (month * 43800) + (day * 1440) + (hour * 60) + (minutes)
    }
}

