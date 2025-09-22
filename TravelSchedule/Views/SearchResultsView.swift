//
//  SearchResultsView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.

import SwiftUI

struct SearchResultsView: View {
    let from: String
    let to: String
    @StateObject private var viewModel = SearchResultsViewModel()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
            } else if let appError = viewModel.appError {
                ErrorView(type: mapError(appError))
            } else if viewModel.results.isEmpty {
                Text("Вариантов нет")
            } else {
                List(viewModel.results, id: \.thread?.uid) { segment in
                    VStack(alignment: .leading) {
                        Text(segment.thread?.carrier?.title ?? "Неизвестный перевозчик")
                            .font(.headline)
                        
                        let departure = segment.departure.flatMap { dateFormatter.string(from: $0) } ?? "?"
                        let arrival = segment.arrival.flatMap { dateFormatter.string(from: $0) } ?? "?"
                        
                        Text("\(departure) → \(arrival)")
                            .font(.subheadline)
                    }
                }
            }
            
            NavigationLink("Уточнить время") {
                FiltersView()
            }
            .buttonStyle(PrimaryButton())
            .padding()
        }
        .navigationTitle("Результаты")
        .task {
            await viewModel.loadResults(from: from, to: to)
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
