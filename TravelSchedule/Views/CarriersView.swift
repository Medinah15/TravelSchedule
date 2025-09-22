//
//  CarriersView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

struct CarriersView: View {
    @StateObject private var viewModel = CarriersViewModel()
    let carrierCode: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
            } else if let appError = viewModel.appError {
                ErrorView(type: mapError(appError))
            } else if viewModel.carriers.isEmpty {
                Text("Вариантов нет")
                    .foregroundColor(.gray)
            } else {
                List(viewModel.carriers, id: \.code) { carrier in
                    VStack(alignment: .leading) {
                        Text(carrier.title ?? "Без названия")
                            .font(.headline)
                        Text("Код: \(carrier.code.map { String($0) } ?? "-")")
                            .font(.subheadline)
                    }
                }
                
            }
        }
        .navigationTitle("Перевозчики")
        .task {
            await viewModel.loadCarrier(code: carrierCode)
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
