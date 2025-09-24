//
//  NetworkManager.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import Foundation
import OpenAPIURLSession

// MARK: - Network Manager
final class NetworkManager {
    
    // MARK: - Shared Instance
    static let shared = NetworkManager()
    
    // MARK: - Public Properties
    let client: Client
    let apiKey: String
    
    // MARK: - Init
    private init() {
        self.apiKey = Config.yandexAPIKey
        self.client = Client(
            serverURL: URL(string: "https://api.rasp.yandex.net")!,
            transport: URLSessionTransport()
        )
    }
}
