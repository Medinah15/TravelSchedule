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
}

// MARK: - View
struct ErrorView: View {
    
    // MARK: - Properties
    let type: ErrorType
    
    // MARK: - Body
    var body: some View {
        VStack {
            Image(type == .noInternet ? "no_internet" : "server_error")
                .resizable()
                .frame(width: 223, height: 223)
                .padding()
            Text(type == .noInternet ? "Нет интернета" : "Ошибка сервера")
                .font(.headline)
        }
    }
}
