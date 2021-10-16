//
//  GasStation.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import Foundation

struct GasStation: Decodable {
    let address: String
    let place: String
    let timetable: String
    let label: String
    let municipality: String
    let idGo: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "Dirección"
        case timetable = "Horario"
        case municipality = "Municipio"
        case label = "Rótulo"
        case price = "PrecioProducto"
        case place = "Localidad"
        case idGo = "IDEESS"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        idGo = try values.decode(String.self, forKey: .idGo)
        address = try values.decode(String.self, forKey: .address)
        place = try values.decode(String.self, forKey: .place)
        timetable = try values.decode(String.self, forKey: .timetable)
        municipality = try values.decode(String.self, forKey: .municipality)
        label = try values.decode(String.self, forKey: .label)
         
        let priceString = try values.decode(String.self, forKey: .price).replacingOccurrences(of: ",", with: ".")
        price = Double(priceString)!
    }
}

extension GasStation {
    init(cdGo: CDGo) {
        self.address = cdGo.address ?? "NO address"
        self.timetable = cdGo.timetable ?? "NO timetable"
        self.municipality = cdGo.municipality ?? "NO municipality"
        self.label = cdGo.label ?? "NO label"
        self.price = cdGo.price
        self.place = cdGo.place ?? "NO place"
        self.idGo = cdGo.idGo ?? "NO idGo"
    }
}

extension GasStation: Identifiable {
    var id: UUID {
        return UUID()
    }
}

