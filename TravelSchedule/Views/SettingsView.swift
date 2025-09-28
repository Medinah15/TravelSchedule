//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
//
import SwiftUI

// MARK: - View
struct SettingsView: View {
    
    // MARK: - Properties
    @AppStorage("appTheme") private var appTheme: String = AppTheme.light.rawValue
    @State private var showAgreement = false
    
    private var isDarkMode: Binding<Bool> {
        Binding(
            get: { appTheme == AppTheme.dark.rawValue },
            set: { appTheme = $0 ? AppTheme.dark.rawValue : AppTheme.light.rawValue }
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                
                HStack {
                    Text("Тёмная тема")
                        .font(.system(size: 17))
                        .foregroundStyle(.primary)
                    Spacer()
                    Toggle("", isOn: isDarkMode)
                        .labelsHidden()
                        .tint(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                Button(action: { showAgreement = true }) {
                    HStack {
                        Text("Пользовательское соглашение")
                            .font(.system(size: 17))
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color("BlackUniversal"))
                            .frame(width: 11, height: 19)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.top, 16)
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Приложение использует API Яндекс.Расписания")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("BlackUniversal"))
                Text("Версия 1.0 (beta)")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("BlackUniversal"))
            }
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .fullScreenCover(isPresented: $showAgreement) {
            UserAgreementView()
                .toolbar(.hidden, for: .tabBar)
        }
    }
}
