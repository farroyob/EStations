//
//  ProductsListView.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct ProductsListView: View {
    @ObservedObject private var viewModel = ProductListViewModel()
    
    @EnvironmentObject var contentViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List(viewModel.elements) { currentProduct in
                ProductElementRow(elem: currentProduct) { selectedElement in
                    self.contentViewModel.selectedProduct = selectedElement
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarBackButtonHidden(false)
            .navigationTitle("ListProducts")
            .edgesIgnoringSafeArea(.top)
            .listRowBackground(Color.clear)
            .background(Color.clear)
        }
        .onAppear {
            viewModel.getProducts()
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
        .background(Color("clAction"))
        .ignoresSafeArea(.all, edges: .top)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
    }
}
