//
//  FlexibleDateDecoder.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 08.09.25.
//
import Foundation

final class RouteStationsServiceDateDecoder {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            if let date = isoFormatter.date(from: dateStr) {
                return date
            }
            
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
            fallbackFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let date = fallbackFormatter.date(from: dateStr) {
                return date
            }
            
            let yandexFormatter = DateFormatter()
            yandexFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            yandexFormatter.locale = Locale(identifier: "en_US_POSIX")
            yandexFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
            if let date = yandexFormatter.date(from: dateStr) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(dateStr)"
            )
        }
        return decoder
    }()
}
