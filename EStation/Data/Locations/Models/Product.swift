//
//  Product.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation

struct Product {
    let idProduct: String
    let productName: String
    let shortProductName: String
}

extension Product: Decodable {
    enum CodingKeys: String, CodingKey {
        case idProduct = "IDProducto"
        case productName = "NombreProducto"
        case shortProductName = "NombreProductoAbreviatura"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        idProduct = try values.decode(String.self, forKey: .idProduct)
        productName = try values.decode(String.self, forKey: .productName)
        shortProductName = try values.decode(String.self, forKey: .shortProductName)
    }
}

extension Product {
    init(cdProduct: CDProduct) {
        self.idProduct = cdProduct.id ?? "NO idProduct"
        self.productName = cdProduct.name ?? "NO nameProduct"
        self.shortProductName = cdProduct.shortName ?? "NO shortProductName"
    }
}

extension Product: Identifiable {
    var id: UUID {
        return UUID()
    }
}






 
 


 
