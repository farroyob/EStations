//
//  HomeView.swift
//  EStation
//
//  Created by Freddy A. on 10/11/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @ObservedObject var timerManager = TimerManager()
    
    //@State var timeRemaining = 10
    //@State var currentDate = Date()
    //let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // No supe llamar a los metodos por medio de un timer para que actulizaran la DB
    // de forma automatica solo se realiza al realizar la llamada al metodo que verifica
    // que haya pasado mas de 30 minutos para realizar el borrado y actualizan de los datos
        
    var body: some View {
        VStack{
            HStack{
                Text("EStation")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
            }
            .padding()
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color("clAction"))
            
            /*
            Text("\(currentDate)")
                .onReceive(timer) { input in
                    currentDate = input
                }
            
            Text("\(timeRemaining)")
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        
                        //viewModel.getGasStations(idProvince: "idProvince", idProduct: "idProduct")
                    }
                }
             */
            
            NavigationView {
                List {
                    Section(header: Text("homeSectionCCAA")) {
                        NavigationLink(destination: CCAAListView()) {
                            if let name = viewModel.selectedCCAA?.name {
                                Text(name)
                            } else {
                                Text("homeSelectCCAA")
                            }
                        }
                        NavigationLink(destination: ProvinceListView()) {
                            if let name = viewModel.selectedProvince?.name {
                                Text(camelCaseName(valueName: name))
                            } else {
                                Text("homeSelectProvince")
                            }
                        }
                        .disabled(viewModel.selectedCCAA == nil)
                    }
                   
                    Section(header: Text("homeSectionProduct")) {
                        NavigationLink(destination: ProductsListView()) {
                            if let name = viewModel.selectedProduct?.name {
                                Text(name)
                            } else {
                                Text("homeSelectProduct")
                            }
                        }
                    }
                    
                    Section(header: Text("homeSectionGo")) {
                        NavigationLink(destination: GasStationsListView()) {
                            if let name = viewModel.selectedGo?.label, let price = viewModel.selectedGo?.price {
                                Text("\(name) -> \(price)€")
                            } else {
                                Text("homeSelectGo")
                            }
                        }
                        .disabled((viewModel.selectedProvince == nil) || (viewModel.selectedProduct == nil))
                    }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.top)
            }
            
            .environmentObject(viewModel)
        }
        .background(Color("clAction"))
        .ignoresSafeArea(.all, edges: .top)
        .edgesIgnoringSafeArea(.top)
        .accentColor(.black)
        
        .onAppear{
            timerManager.start()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
