//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
//
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
            } else if let appError = viewModel.appError {
                ErrorView(type: mapError(appError))
            } else {
                Text("Экран настроек (данные успешно загружены)")
                    .padding()
            }
        }
        .task {
            await viewModel.loadSettings()
        }
    }
    
    private func mapError(_ error: AppError) -> ErrorType {
        switch error {
        case .noInternet: return .noInternet
        case .serverError: return .serverError
        default: return .serverError
        }
    }
}
