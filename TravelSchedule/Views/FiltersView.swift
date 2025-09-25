//
//  FiltersView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

// MARK: - View
struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var morning = false
    @State private var day = false
    @State private var evening = false
    @State private var night = false
    
    @State private var transfers: Bool? = nil
    
    // MARK: - Derived
    private var isApplyEnabled: Bool {
        (morning || day || evening || night) && transfers != nil
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundColor(.black)
                        .navigationBarBackButtonHidden(true)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 27)
            
            VStack(alignment: .leading, spacing: 38) {
                timeRow(title: "Утро 06:00 – 12:00", isOn: $morning)
                timeRow(title: "День 12:00 – 18:00", isOn: $day)
                timeRow(title: "Вечер 18:00 – 00:00", isOn: $evening)
                timeRow(title: "Ночь 00:00 – 06:00", isOn: $night)
            }
            .padding(.horizontal, 16)
            .padding(.top, 35)
            
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 35)
            
            VStack(alignment: .leading, spacing: 38) {
                transferRow(title: "Да", selected: transfers == true) {
                    transfers = true
                }
                transferRow(title: "Нет", selected: transfers == false) {
                    transfers = false
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 35)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Применить")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isApplyEnabled ? Color(red: 55/255, green: 114/255, blue: 231/255) : Color.clear)
                
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .disabled(!isApplyEnabled)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Helpers
    
    private func timeRow(title: String, isOn: Binding<Bool>) -> some View {
        Button(action: { isOn.wrappedValue.toggle() }) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: isOn.wrappedValue ? "checkmark.square.fill" : "square")
                    .foregroundColor(isOn.wrappedValue ? .black : .black)
                    .font(.system(size: 20))
            }
        }
    }
    
    private func transferRow(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(selected ? .black : .black)
                    .font(.system(size: 20))
            }
        }
    }
}
