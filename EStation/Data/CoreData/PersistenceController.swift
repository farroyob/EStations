//
//  Persistence.swift
//  EStation
//
//  Created by Freddy A. on 10/5/21.
//

import Foundation
import CoreData
import Combine

protocol PersistenceControllerType {
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

struct PersistenceController {
    static let shared = PersistenceController()
    
    private let container: NSPersistentContainer
    
    var mainMOC: NSManagedObjectContext {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EStation")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

extension PersistenceController: PersistenceControllerType {
    //******************************************************************************************************************
    // CCAA
    //******************************************************************************************************************
    
    func getCCAA() -> AnyPublisher<[CCAA], Error> {
        return Future<[CCAA], Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest = CDCCAA.fetchRequest()
                fetchRequest.predicate = nil
                
                var result: [CDCCAA]?
                do {
                    result = try context.fetch(fetchRequest)
                } catch {
                    promise(Result.failure(error))
                }
                
                if let result = result {
                    let convertedResult = result.map { CCAA(cdCCAA: $0) }
                    promise(Result.success(convertedResult))
                } else {
                    promise(Result.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error> {
        return Future<[CCAA], Error>() { promise in
            container.performBackgroundTask { context in
                ccaaList.forEach { currentCCAA in
                    let newCCAAEntry = CDCCAA(context: context)
                    newCCAAEntry.ccaaName = currentCCAA.ccaaName
                    newCCAAEntry.idCCAA = currentCCAA.idCCAA
                }
                
                do {
                    try context.save()
                    promise(.success(ccaaList))
                } catch {
                    print("There was an error saving \(ccaaList.count) CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteCCAAs(with ccaaNames: [String]) -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCCAA.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "self.ccaaName in %@", ccaaNames)
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteAllCCAAs() -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCCAA.fetchRequest()
                fetchRequest.predicate = nil
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //******************************************************************************************************************
    // PROVINCES
    //******************************************************************************************************************
    
    func getProvinces(idCCAA: String?) -> AnyPublisher<[Province], Error> {
        return Future<[Province], Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest = CDProvince.fetchRequest()
                if let idCCAA = idCCAA {
                    fetchRequest.predicate = NSPredicate(format: "self.belongs.idCCAA like %@", idCCAA)
                } else {
                    fetchRequest.predicate = nil
                }
                
                var result: [CDProvince]?
                do {
                    result = try context.fetch(fetchRequest)
                } catch {
                    promise(Result.failure(error))
                }
                
                if let result = result {
                    let convertedResult = result.map { Province(cdProvince: $0) }
                    promise(.success(convertedResult))
                } else {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error> {
        Future { promise in
            container.performBackgroundTask { context in
                
                var indexedEntries: [String: [CDProvince]] = [:]
                
                provincesList.forEach { currentProvince in
                    
                    let newEntry = CDProvince(context: context)
                    newEntry.provinceName = currentProvince.provinceName
                    newEntry.idProvince = currentProvince.idProvince
                    
                    if let existingProvinces = indexedEntries[currentProvince.idCCAA] {
                        indexedEntries[currentProvince.idCCAA] = existingProvinces + [newEntry]
                    } else {
                        indexedEntries[currentProvince.idCCAA] = [newEntry]
                    }
                }
                
                indexedEntries.forEach { (key: String, value: [CDProvince]) in
                    self.addProvinces(value, idCCAA: key, context: context)
                }
                
                do {
                    try context.save()
                    promise(.success(provincesList))
                } catch {
                    print("Something went wrong: \(error)")
                    promise(.failure(error))
                    context.rollback()
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func addProvinces(_ provinces: [CDProvince],
                              idCCAA: String,
                              context: NSManagedObjectContext) {
        let fetchRequest = CDCCAA.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self.idCCAA like %@", idCCAA)
        
        var result: [CDCCAA]?
        do {
            result = try context.fetch(fetchRequest)
        } catch {
            print("There was an error adding provinces list to existing CCAA")
        }
        
        if let result = result?.first {
            result.addToContains(NSSet.init(array: provinces))
            print("We just added \(provinces.count) CDProvinces to \(result.ccaaName ?? "NO CCAA name")")
        }
    }
    
    func deleteAllProvinces() -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDProvince.fetchRequest()
                fetchRequest.predicate = nil
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //******************************************************************************************************************
    // PRODUCTS
    //******************************************************************************************************************
    
    func productGet() -> AnyPublisher<[Product], Error> {
        return Future<[Product], Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest = CDProduct.fetchRequest()
                fetchRequest.predicate = nil
                
                var result: [CDProduct]?
                do {
                    result = try context.fetch(fetchRequest)
                } catch {
                    promise(Result.failure(error))
                }
                
                if let result = result {
                    let convertedResult = result.map { Product(cdProduct: $0) }
                    promise(.success(convertedResult))
                } else {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func productSave(list: [Product]) -> AnyPublisher<[Product], Error> {
        return Future<[Product], Error>() { promise in
            container.performBackgroundTask { context in
                list.forEach { data in
                    let newEntry = CDProduct(context: context)
                    newEntry.id = data.idProduct
                    newEntry.name = data.productName
                    newEntry.shortName = data.shortProductName
                }
                
                do {
                    try context.save()
                    promise(.success(list))
                } catch {
                    print("There was an error saving \(list.count) Products in batch: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
 
    func productDeleteAll() -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDProduct.fetchRequest()
                fetchRequest.predicate = nil
              
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all Produtcs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //******************************************************************************************************************
    // GO
    //******************************************************************************************************************
    
    func goGet(idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error> {
        return Future<[GasStation], Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest = CDGo.fetchRequest()
                //fetchRequest.predicate = NSPredicate(format: "idProvince like %@ AND idProduct like %@", idProvince )
                fetchRequest.predicate = NSPredicate(format: "idProvince like %@ AND idProduct like %@", argumentArray: [idProvince, idProduct])
                
                var result: [CDGo]?
                do {
                    result = try context.fetch(fetchRequest)
                } catch {
                    promise(Result.failure(error))
                }
                
                if let result = result {
                    let convertedResult = result.map { GasStation(cdGo: $0) }
                    promise(.success(convertedResult))
                } else {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func goSave(list: [GasStation], idProvince: String, idProduct: String) -> AnyPublisher<[GasStation], Error> {
        return Future<[GasStation], Error>() { promise in
            container.performBackgroundTask { context in
                list.forEach { data in
                    let newEntry = CDGo(context: context)
                    newEntry.idProvince = idProvince
                    newEntry.idProduct = idProduct
                    newEntry.price = data.price
                    newEntry.timetable = data.timetable
                    newEntry.municipality = data.municipality
                    newEntry.label = data.label
                    newEntry.address = data.address
                    newEntry.place = data.place
                    newEntry.idGo = data.idGo
                }
                
                do {
                    try context.save()
                    promise(.success(list))
                } catch {
                    print("There was an error saving \(list.count) Go in batch: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func goDelete(idProvince: String, idProduct: String) -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDProduct.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "idProvince like %@ AND idProduct like %@", argumentArray: [idProvince, idProduct])
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting Go for Province & Product in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func goDeleteAll() -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDGo.fetchRequest()
                fetchRequest.predicate = nil
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all Go in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
