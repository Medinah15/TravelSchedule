//
//  CarriersViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

// MARK: - ViewModel
@MainActor
final class CarriersViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var carrier: Components.Schemas.Carrier?
    @Published var isLoading = false
    @Published var appError: AppError?
    
    // MARK: - Private Properties
    private let service: CarrierInfoServiceProtocol
    
    // MARK: - Init
    init(service: CarrierInfoServiceProtocol = CarrierInfoService(
        client: NetworkManager.shared.client,
        apikey: NetworkManager.shared.apiKey
    )) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func loadCarrier(code: String) async {
        isLoading = true
        appError = nil
        do {
            let response = try await service.getCarrierInfo(code: code)
            self.carrier = response.carriers?.first
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
