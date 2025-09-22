//
//  CityPickerViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

@MainActor
final class CityPickerViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    private let service: AllStationsServiceProtocol
    
    init(service: AllStationsServiceProtocol = AllStationsService(
        client: NetworkManager.shared.client,
        apikey: NetworkManager.shared.apiKey
    )) {
        self.service = service
    }
    
    func loadCities() async {
        isLoading = true
        appError = nil
        do {
            let data = try await service.getAllStations()
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
        } catch {
        }
        isLoading = false
    }
}
