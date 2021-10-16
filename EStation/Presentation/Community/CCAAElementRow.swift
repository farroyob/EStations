//
//  CCAAElementRow.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct CCAAElementRow: View {
    var elem: DomainCCAA
    let onTap: (DomainCCAA) -> Void
    
    var body: some View {
        HStack {
            Image(elem.id)
                .resizable()
                .frame(width: 80, height: 80, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .top, .bottom], 8)
            
            
            Text(elem.name)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 80, alignment: .leading)
                .font(.system(size: 17, weight: .light, design: .serif))
                
            
            
        }
        .onTapGesture {
            onTap(elem)
        }
    }
}
/*
struct CCAAElementRow_Previews: PreviewProvider {
    static var previews: some View {
        CCAAElementRow(elem: DomainCCAA(id: "01", name: "Comunidad Foral de Navarra", provinces: []))
    }
}
*/
