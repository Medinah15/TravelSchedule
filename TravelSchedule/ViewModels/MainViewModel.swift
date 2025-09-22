//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    @Published var appError: AppError?
    
    func simulateErrorCheck() {
        let connected = Reachability.isConnectedToNetwork()
        if !connected {
            appError = .noInternet
        }
    }
}
