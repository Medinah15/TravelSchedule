//
//  SearchResultsViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

@MainActor
final class SearchResultsViewModel: ObservableObject {
    @Published var results: [Components.Schemas.Segment] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    private let service: SearchServiceProtocol
    
    init(service: SearchServiceProtocol = SearchService(
        client: NetworkManager.shared.client,
        apikey: NetworkManager.shared.apiKey
    )) {
        self.service = service
    }
    
    func loadResults(from: String, to: String) async {
        isLoading = true
        appError = nil
        do {
            let data = try await service.getSchedule(from: from, to: to)
            self.results = data.segments ?? []
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
