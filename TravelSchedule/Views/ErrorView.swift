//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

enum ErrorType {
    case noInternet
    case serverError
}

struct ErrorView: View {
    let type: ErrorType
    
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
