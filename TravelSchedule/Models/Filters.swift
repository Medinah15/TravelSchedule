//
//  Filters.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//
import Foundation

struct Filters: Equatable, Sendable {
    let morning: Bool
    let day: Bool
    let evening: Bool
    let night: Bool
    let transfers: Bool
}
