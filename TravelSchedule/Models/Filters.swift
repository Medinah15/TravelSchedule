//
//  Filters.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//
import Foundation

struct Filters: Equatable, Sendable {
    var morning: Bool
    var day: Bool
    var evening: Bool
    var night: Bool
    var transfers: Bool
}
