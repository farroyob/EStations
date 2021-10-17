//
//  CCAAListView.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct CCAAListView: View {
    @ObservedObject private var viewModel = CCAAListViewModel()
    
    @EnvironmentObject var contentViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            List(viewModel.elements) { currentCCAA in
                CCAAElementRow(elem: currentCCAA) { selectedElement in
                    self.contentViewModel.selectedCCAA = selectedElement
                    self.contentViewModel.selectedProvince = nil
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarBackButtonHidden(false)
            .navigationTitle("ListCCAA")
            .edgesIgnoringSafeArea(.top)
            
        }
        .onAppear {
            viewModel.getCCAAs()
        }
        .background(Color("clAction"))
        .ignoresSafeArea(.all, edges: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct CCAAListView_Previews: PreviewProvider {
    static var previews: some View {
        CCAAListView()
    }
}
