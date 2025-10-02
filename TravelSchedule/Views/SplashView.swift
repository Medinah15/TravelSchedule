//
//  SplashView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
import SwiftUI

// MARK: - View
struct SplashView: View {
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color("BlackUniversal").ignoresSafeArea()
            Image("splash_screen")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SplashView()
}
