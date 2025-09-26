//
//  MockSearchService.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 24.09.25.
//

import Foundation

// MARK: - Mock Service
final class MockSearchService: SearchServiceProtocol {
    
    // MARK: - Properties
    var mockResponse: SearchResponse
    
    // MARK: - Init
    init(mockResponse: SearchResponse) {
        self.mockResponse = mockResponse
    }
    
    // MARK: - Public Methods
    func getSchedule(from: String, to: String) async throws -> SearchResponse {
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockResponse
    }
}
