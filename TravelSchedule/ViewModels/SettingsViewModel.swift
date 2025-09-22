//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 22.09.25.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var appError: AppError?
    
    func loadSettings() async {
        isLoading = true
        defer { isLoading = false }
        
        await Task.sleep(1_000_000_000) 
        
        appError = .noInternet
    }
}

