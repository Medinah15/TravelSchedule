//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

// MARK: - Error Type

enum ErrorType {
    case noInternet
    case serverError
    
    var imageName: String {
        switch self {
        case .noInternet: "no_internet"
        case .serverError: "server_error"
        }
    }
    
    var message: String {
        switch self {
        case .noInternet: "Нет интернета"
        case .serverError: "Ошибка сервера"
        }
    }
}

// MARK: - View

struct ErrorView: View {
    let type: ErrorType
    
    var body: some View {
        VStack {
            Image(type.imageName)
                .resizable()
                .frame(width: 223, height: 223)
                .padding()
            
            Text(type.message)
                .font(.headline)
        }
    }
}
