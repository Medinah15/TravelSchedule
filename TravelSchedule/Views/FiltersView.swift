//
//  FiltersView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var morning = false
    @State private var day = false
    @State private var evening = false
    @State private var night = false
    @State private var withTransfers = true
    
    var body: some View {
        Form {
            Section("Время отправления") {
                Toggle("Утро 06:00–12:00", isOn: $morning)
                Toggle("День 12:00–18:00", isOn: $day)
                Toggle("Вечер 18:00–00:00", isOn: $evening)
                Toggle("Ночь 00:00–06:00", isOn: $night)
            }
            
            Section("С пересадками") {
                Picker("Пересадки", selection: $withTransfers) {
                    Text("Да").tag(true)
                    Text("Нет").tag(false)
                }
                .pickerStyle(.segmented)
            }
            
            Button("Применить") {
                dismiss()
            }
            .buttonStyle(PrimaryButton())
        }
        .navigationTitle("Фильтры")
    }
}
