//
//  ProvinceElementRow.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct ProvinceElementRow: View {
    var elem: DomainProvince
    let idCCAA: String?
    let onTap: (DomainProvince) -> Void
            
    var body: some View {
        HStack {
            if let idCCAA = idCCAA {
                Image(idCCAA + "_" + elem.id)
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .top, .bottom], 8)
            } else {
                Image("00_00")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .top, .bottom], 8)
            }
            
            Text(camelCaseName(valueName: elem.name))
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80, alignment: .leading)
                .font(.system(size: 17, weight: .light, design: .serif))
            
            
            
        }
        .onTapGesture {
            onTap(elem)
        }
    }
}

/*
struct ProvinceElementRow_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceElementRow()
    }
}
*/
