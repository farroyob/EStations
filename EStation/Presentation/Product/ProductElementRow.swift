//
//  ProductElementRow.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct ProductElementRow: View {
    var elem: DomainProduct
    let onTap: (DomainProduct) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text(elem.name)
            
            HStack {
                Spacer()
                Text(elem.shortName)
                    .font(.system(size: 12))
                    .padding(.trailing, 16)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color("clAction"))
        .foregroundColor(Color.white)
        .cornerRadius(20.0)
        .onTapGesture {
            onTap(elem)
        }
    }
}

/*
struct ProductElementRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductElementRow(elem: DomainProduct(id: "1", name: "Gasolina 95 E5", shortName: "G95E5"))
    }
}

*/
