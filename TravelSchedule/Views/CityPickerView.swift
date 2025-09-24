//
//  CityPickerView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.

import SwiftUI

// MARK: - View
struct CityPickerView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @StateObject private var viewModel = CityPickerViewModel()
    
    let onSelect: (City) -> Void
    
    // MARK: - Computed
    var filteredCities: [City] {
        if searchText.isEmpty { return viewModel.cities }
        return viewModel.cities.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundColor(.black)
                }
                .padding(.leading, 8)
                .padding(.vertical, 11)
                
                Spacer()
                
                Text("Выбор города")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Color.clear
                    .frame(width: 17, height: 22)
                    .padding(.trailing, 8)
            }
            .padding(.bottom, 4)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Поиск", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загрузка...")
                Spacer()
            } else if let appError = viewModel.appError {
                Spacer()
                ErrorView(type: mapError(appError))
                Spacer()
            } else if filteredCities.isEmpty {
                Spacer()
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            } else {
                List {
                    ForEach(filteredCities) { city in
                        Button {
                            onSelect(city)
                        } label: {
                            HStack {
                                Text(city.title)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.black)
                                    .frame(width: 11, height: 19)
                            }
                            .frame(height: 58)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationBarHidden(true)
        .task { await viewModel.loadCities() }
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
