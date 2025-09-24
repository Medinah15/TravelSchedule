//
//  SplashView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
import SwiftUI

// MARK: - View
struct SplashView: View {
    
    // MARK: - State
    @State private var showMain = false
    
    // MARK: - Body
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
