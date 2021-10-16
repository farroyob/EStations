//
//  GasStationsListView.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct GasStationsListView: View {
    @ObservedObject private var viewModel = GasStationListViewModel()
    
    @EnvironmentObject var contentViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List(viewModel.elements) { currentGasStation in
                GasStationElementRow(elem: currentGasStation) { selectedElement in
                    self.contentViewModel.selectedGo = selectedElement
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("ListGo")
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            guard let idProvince = contentViewModel.selectedProvince?.id,
                  let idProduct = contentViewModel.selectedProduct?.id else {
                      return
                  }
            
            viewModel.getGasStations(idProvince: idProvince, idProduct: idProduct)
        }
        .background(Color("clAction"))
        .ignoresSafeArea(.all, edges: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct GasStationsListView_Previews: PreviewProvider {
    static var previews: some View {
        GasStationsListView()
    }
}


