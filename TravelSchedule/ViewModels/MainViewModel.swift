//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

// MARK: - ViewModel
@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var appError: AppError?
    
    // MARK: - Public Methods
    func simulateErrorCheck() {
        let connected = Reachability.isConnectedToNetwork()
        if !connected {
            appError = .noInternet
        }
    }
}
