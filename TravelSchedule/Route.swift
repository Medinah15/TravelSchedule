//
//  Route.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 24.09.25.
//

import Foundation

enum Route: Hashable {
    case cityPicker(isFrom: Bool)
    case stationPicker(cityId: String, cityTitle: String, isFrom: Bool)
    case searchResults(fromCode: String, toCode: String, fromTitle: String, toTitle: String)
    case carrierInfo(code: String)
}
