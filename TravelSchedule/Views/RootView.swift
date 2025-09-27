//
//  RootView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("appTheme") private var appTheme: String = AppTheme.light.rawValue
    @State private var showMain = false

    var body: some View {
        ZStack {
            if showMain {
                AppTabView()
            } else {
                SplashView()
            }
        }
        .preferredColorScheme(appTheme == AppTheme.dark.rawValue ? .dark : .light) // 🔹 применяем тут
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showMain = true
                }
            }
        }
    }
}

#Preview {
    RootView()
}
