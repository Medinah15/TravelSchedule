//
//  CarriersView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

// MARK: - View
struct CarriersView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = CarriersViewModel()
    let carrierCode: String
    
    // MARK: - Body
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
            } else if let appError = viewModel.appError {
                ErrorView(type: mapError(appError))
            } else if let carrier = viewModel.carrier {
                VStack(alignment: .leading, spacing: 8) {
                    if let logo = carrier.logo, let url = URL(string: logo) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(carrier.title ?? "Без названия")
                        .font(.title2)
                        .bold()
                    
                    if let code = carrier.code {
                        Text("Код: \(code)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let phone = carrier.phone {
                        Text("Телефон: \(phone)")
                            .font(.subheadline)
                    }
                    
                    if let url = carrier.url {
                        Text("Сайт: \(url)")
                            .font(.subheadline)
                    }
                }
                .padding()
            } else {
                Text("Перевозчик не найден")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Перевозчик")
        .task {
            await viewModel.loadCarrier(code: carrierCode)
        }
    }
    
    // MARK: - Helpers
    private func mapError(_ error: AppError) -> ErrorType {
        switch error {
        case .noInternet: return .noInternet
        case .serverError: return .serverError
        default: return .serverError
        }
    }
}
