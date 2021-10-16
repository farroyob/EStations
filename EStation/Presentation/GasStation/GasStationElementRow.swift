//
//  GasStationElementRow.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct GasStationElementRow: View {
    var elem: DomainGasStation
    let onTap: (DomainGasStation) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("GoPrice")
                Text("\(elem.price)€")
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
            }
            .padding(.all, 4)
            
            HStack(spacing: 0) {
                Text("GoLabel")
                Text(camelCaseName(valueName:elem.label))
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
            }
            .padding(.all, 4)
            
            HStack(spacing: 0) {
                Text("GoTimeTable")
                Text(elem.timetable)
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
            }
            .padding(.all, 4)
            
            HStack(spacing: 0) {
                Text("GoMunicipality")
                
                Text(camelCaseName(valueName:elem.municipality))
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
            }
            .padding(.all, 4)
            
            HStack(spacing: 0) {
                Text("GoLoc")
                
                Text(camelCaseName(valueName:elem.place))
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
            }
            .padding(.all, 4)
            
            HStack {
                Text(camelCaseName(valueName:elem.address))
                    .font(.system(size: 12))
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .contentShape(Rectangle())
            }
            .padding(.all, 4)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color("clAction"))
        .foregroundColor(Color.white)
        .cornerRadius(20.0)
        .onTapGesture {
            onTap(elem)
        }
    }
}
/*
struct GasStationElementRow_Previews: PreviewProvider {
    static var previews: some View {
        GasStationElementRow()
    }
}
*/
