//
//  Util.swift
//  EStation
//
//  Created by Freddy A. on 10/12/21.
//

import Foundation
import SwiftUI

extension View {
    func camelCaseName(valueName: String) -> String {
        var indicateUpper: Bool
        var nameTemp: String = ""
        var name: String
        
        name = valueName.lowercased()
        indicateUpper = true
        
        for char in name {
            if (indicateUpper) {
                nameTemp = nameTemp + String(char).uppercased()
                
                indicateUpper = false
            } else {
                nameTemp = nameTemp + String(char)
            }
            
            if (char == " "
                || char == "."
                || char == "?"
                || char == "/"
            ) {
                indicateUpper = true
            }
        }
        
        return nameTemp
    }
}
