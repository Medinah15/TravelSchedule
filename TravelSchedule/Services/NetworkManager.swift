//
//  NetworkManager.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import Foundation
import OpenAPIURLSession

final class NetworkManager {
    static let shared = NetworkManager()
    
    let client: Client
    let apiKey: String
    
    private init() {
        self.apiKey = Config.yandexAPIKey
        self.client = Client(
            serverURL: URL(string: "https://api.rasp.yandex.net")!,
            transport: URLSessionTransport()
        )
    }
}
