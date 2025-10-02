//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 01.10.25.
//

import SwiftUI

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
