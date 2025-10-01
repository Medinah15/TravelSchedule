//
//  FiltersView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FiltersViewModel()
    
    let onApply: (Filters) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                        .foregroundStyle(.primary)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 27)
            
            VStack(alignment: .leading, spacing: 38) {
                TimeRowView(title: "Утро 06:00 – 12:00", isOn: $viewModel.morning)
                TimeRowView(title: "День 12:00 – 18:00", isOn: $viewModel.day)
                TimeRowView(title: "Вечер 18:00 – 00:00", isOn: $viewModel.evening)
                TimeRowView(title: "Ночь 00:00 – 06:00", isOn: $viewModel.night)
            }
            .padding(.horizontal, 16)
            .padding(.top, 35)
            
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 35)
            
            VStack(alignment: .leading, spacing: 38) {
                TransferRowView(title: "Да",
                                isSelected: viewModel.transfers == true,
                                onTap: { viewModel.selectTransfer(true) })
                
                TransferRowView(title: "Нет",
                                isSelected: viewModel.transfers == false,
                                onTap: { viewModel.selectTransfer(false) })
            }
            .padding(.horizontal, 16)
            .padding(.top, 35)
            
            Spacer()
            
            Button {
                if let filters = viewModel.buildFilters() {
                    onApply(filters)
                    dismiss()
                }
            } label: {
                Text("Применить")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isApplyEnabled ? Color("BlueUniversal") : Color.clear)
                    .foregroundStyle(viewModel.isApplyEnabled ? Color("WhiteUniversal") : .clear)
                    .cornerRadius(16)
            }
            .disabled(!viewModel.isApplyEnabled)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}
