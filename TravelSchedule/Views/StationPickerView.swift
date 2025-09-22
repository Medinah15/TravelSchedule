//
//  StationPickerView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
//

import SwiftUI

struct StationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @StateObject private var viewModel: StationPickerViewModel
    
    let onSelect: (SelectedStation) -> Void
    
    init(city: String, onSelect: @escaping (SelectedStation) -> Void) {
        _viewModel = StateObject(wrappedValue: StationPickerViewModel(city: city))
        self.onSelect = onSelect
    }
    
    var filteredStations: [(title: String, code: String)] {
        if searchText.isEmpty { return viewModel.stations }
        return viewModel.stations.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                } else if let appError = viewModel.appError {
                    ErrorView(type: mapError(appError))
                } else {
                    List {
                        if filteredStations.isEmpty {
                            Text("Станции не найдены")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(filteredStations, id: \.code) { station in
                                Button {
                                    onSelect(SelectedStation(title: station.title, code: station.code))
                                    dismiss()
                                } label: {
                                    Text(station.title)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Выбор станции")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") { dismiss() }
                }
            }
            .task {
                await viewModel.loadStations()
            }
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
