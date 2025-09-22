//
//  SplashView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
import SwiftUI

struct SplashView: View {
    @State private var showMain = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image("splash_screen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showMain = true
                }
            }
        }
        .fullScreenCover(isPresented: $showMain) {
            AppTabView()
        }
    }
}

#Preview {
    SplashView()
}
