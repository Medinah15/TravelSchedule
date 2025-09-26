//
//  PrimaryButton.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.cornerRadius(12))
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
