//
//  StationPickerViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

@MainActor
final class StationPickerViewModel: ObservableObject {
    @Published var stations: [(title: String, code: String)] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    private let service: AllStationsServiceProtocol
    private let city: String
    
    init(city: String,
         service: AllStationsServiceProtocol = AllStationsService(
            client: NetworkManager.shared.client,
            apikey: NetworkManager.shared.apiKey
         )) {
             self.city = city
             self.service = service
         }
    
    func loadStations() async {
        isLoading = true
        appError = nil
        do {
            let data = try await service.getAllStations()
            
            let settlements = data.countries?
                .flatMap { $0.regions ?? [] }
                .flatMap { $0.settlements ?? [] }
            
            let targetSettlement = settlements?.first { $0.title == city }
            let stationsList = targetSettlement?.stations ?? []
            
            self.stations = stationsList.compactMap { station in
                if let title = station.title,
                   let code = station.codes?.yandex_code {
                    return (title, code)
                }
                return nil
            }
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
