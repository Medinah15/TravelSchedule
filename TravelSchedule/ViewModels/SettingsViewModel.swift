//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 22.09.25.
//

import Foundation

// MARK: - ViewModel
@MainActor
final class SettingsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var appError: AppError?
    
    // MARK: - Public Methods
    func loadSettings() async {
        isLoading = true
        appError = nil
        
        defer { isLoading = false }
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
        } catch {
            appError = .unknown
        }
        appError = .noInternet
    }
}
