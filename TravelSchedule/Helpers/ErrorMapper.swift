//
//  ErrorMapper.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//

import Foundation

func mapError(_ error: AppError) -> ErrorType {
    switch error {
    case .noInternet: return .noInternet
    case .serverError: return .serverError
    default: return .serverError
    }
}
