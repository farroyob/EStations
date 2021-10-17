//
//  ProvinceListView.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct ProvinceListView: View {
    @ObservedObject private var viewModel = ProvinceListViewModel()
    
    @EnvironmentObject var contentViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List(viewModel.elements) { currentProvince in
                ProvinceElementRow(elem: currentProvince, idCCAA: contentViewModel.selectedCCAA?.id) { selectedElement in
                    self.contentViewModel.selectedProvince = selectedElement
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarBackButtonHidden(false)
            .navigationTitle("ListProvince")
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            viewModel.getProvinces(idCCAA: contentViewModel.selectedCCAA?.id)
        }
        .background(Color("clAction"))
        .ignoresSafeArea(.all, edges: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ProvinceListView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceListView()
    }
}
