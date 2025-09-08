//
//  FlexibleDateDecoder.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 08.09.25.
//

import Foundation

final class FlexibleDateDecoder {
    static let shared = FlexibleDateDecoder()
    
    let decoder: JSONDecoder
    
    private init() {
        decoder = JSONDecoder()
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            if let date = fallbackFormatter.date(from: dateStr) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date: \(dateStr)")
        }
    }
}
