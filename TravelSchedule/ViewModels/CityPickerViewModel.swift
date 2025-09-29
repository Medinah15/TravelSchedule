//
//  CityPickerViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

// MARK: - ViewModel
@MainActor
final class CityPickerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    // MARK: - Public Methods
    func loadCities() async {
        isLoading = true
        appError = nil
        do {
            // ⬇️ теперь используем NetworkClient.shared
            let data = try await NetworkClient.shared.fetchAllStations()
            
            let settlements = data.countries?
                .flatMap { $0.regions ?? [] }
                .flatMap { $0.settlements ?? [] } ?? []
            
            let citiesWithDuplicates = settlements.compactMap { settlement -> City? in
                guard let title = settlement.title,
                      let code = settlement.codes?.yandex_code else { return nil }
                return City(id: code, title: title)
            }
            
            var seen = Set<String>()
            let uniqueCities = citiesWithDuplicates.filter { city in
                if seen.contains(city.id) {
                    return false
                } else {
                    seen.insert(city.id)
                    return true
                }
            }
            
            self.cities = uniqueCities.sorted { $0.title < $1.title }
            
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                appError = .noInternet
            case .badServerResponse, .cannotConnectToHost:
                appError = .serverError
            default:
                appError = .unknown
            }
        } catch {
            appError = .unknown
        }
        
        isLoading = false
    }
}
