//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 06.09.25.
//
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias SearchResponse = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func getSchedule(
        from: String,
        to: String
    ) async throws -> SearchResponse
}

final class SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedule(from: String, to: String) async throws -> SearchResponse {
        let today = ISO8601DateFormatter().string(from: Date()).prefix(10)
        
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            format: "json",
            date: String(today),
            transport_types: "train"
        ))
        
        guard case let .ok(okResponse) = response else {
            throw URLError(.badServerResponse)
        }
        
        return try okResponse.body.json
    }
}
