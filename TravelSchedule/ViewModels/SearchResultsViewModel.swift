//
//  SearchResultsViewModel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

// MARK: - ViewModel
@MainActor
final class SearchResultsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var results: [Components.Schemas.Segment] = []
    @Published var isLoading = false
    @Published var appError: AppError?
    
    // MARK: - Private Properties
    private let service: SearchServiceProtocol
    
    // MARK: - Init
    init(service: SearchServiceProtocol = SearchService()) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func loadResults(from: String, to: String) async {
        isLoading = true
        appError = nil
        do {
            let data = try await service.getSchedule(from: from, to: to)
            self.results = data.segments ?? []
            print("✅ Успешно загружено сегментов: \(self.results.count)")
        } catch let urlError as URLError {
            print("🌐 URLSession ошибка: \(urlError)")
            switch urlError.code {
            case .notConnectedToInternet:
                appError = .noInternet
            case .badServerResponse, .cannotConnectToHost:
                appError = .serverError
            default:
                appError = .unknown
            }
        } catch {
            print("❌ Неизвестная ошибка загрузки: \(error)")
            appError = .unknown
        }
        isLoading = false
    }
}
