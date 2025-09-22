//
//  CarriersViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

@MainActor
final class CarriersViewModel: ObservableObject {
    @Published var carriers: [Components.Schemas.Carrier] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    private let service: CarrierInfoServiceProtocol
    
    init(service: CarrierInfoServiceProtocol = CarrierInfoService(
        client: NetworkManager.shared.client,
        apikey: NetworkManager.shared.apiKey
    )) {
        self.service = service
    }
    
    func loadCarrier(code: String) async {
        isLoading = true
        appError = nil
        do {
            let response = try await service.getCarrierInfo(code: code)
            self.carriers = response.carriers ?? [] 
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
