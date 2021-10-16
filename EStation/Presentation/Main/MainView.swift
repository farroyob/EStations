//
//  ContentView.swift
//  EStation
//
//  Created by Freddy A. on 10/5/21.
//

import SwiftUI
import CoreData

struct MainView: View {
    @State var animate = false
    @State var endSplash = false
    
    var body: some View {
        ZStack {
            HomeView()
            
            ZStack{
                Color("clAction")
                Image("logoLarge")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 85, height: animate ? nil : 85)
                
                // Scaling View ...
                    .scaleEffect(animate ? 3 : 1)
                // Setting width to avoid over size
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            // hiding view after finished ...
            .opacity(endSplash ? 0 : 1)
        }
    }

    func animateSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(Animation.easeOut(duration: 0.55)){
                animate.toggle()
            }
            
            withAnimation(Animation.easeOut(duration: 0.45)){
                endSplash.toggle()
            }
        }
    }
}
