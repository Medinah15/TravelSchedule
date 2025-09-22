//
//  StationPickerViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

@MainActor
final class StationPickerViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    private let service: AllStationsServiceProtocol
    private let cityId: String
    
    init(cityId: String,
         service: AllStationsServiceProtocol = AllStationsService(
            client: NetworkManager.shared.client,
            apikey: NetworkManager.shared.apiKey
         )) {
             self.cityId = cityId
             self.service = service
         }
    
    func loadStations() async {
        isLoading = true
        appError = nil
        do {
            let data = try await service.getAllStations()
            let settlements = data.countries?
                .flatMap { $0.regions ?? [] }
                .flatMap { $0.settlements ?? [] } ?? []
            
            guard let selectedCity = settlements.first(where: { $0.codes?.yandex_code == cityId }) else {
                self.stations = []
                isLoading = false
                return
            }
            
            let stationsInCity = selectedCity.stations?.compactMap { station -> Station? in
                guard let code = station.codes?.yandex_code,
                      let title = station.title else { return nil }
                return Station(id: code, title: title)
            } ?? []
            
            self.stations = stationsInCity.sorted { $0.title < $1.title }
        } catch {
            appError = .serverError
        }
        isLoading = false
    }
}
