//
//  SearchPanel.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
//
import SwiftUI

struct SearchPanel: View {
    
    // MARK: - Bindings
    @Binding var from: String
    @Binding var to: String
    
    // MARK: - Callbacks
    let onSwap: () -> Void
    let onFromTap: () -> Void
    let onToTap: () -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 55/255, green: 114/255, blue: 231/255))
                .frame(height: 128)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .padding([.vertical, .leading], 16)
                .padding(.trailing, 68)
            VStack(alignment: .leading, spacing: 0) {
                Button(action: onFromTap) {
                    HStack {
                        Text(from.isEmpty ? "Откуда" : from)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(from.isEmpty
                                             ? Color(red: 174/255, green: 175/255, blue: 180/255)
                                             : .black)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button(action: onToTap) {
                    HStack {
                        Text(to.isEmpty ? "Куда" : to)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(to.isEmpty
                                             ? Color(red: 174/255, green: 175/255, blue: 180/255)
                                             : .black)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
        }
        
        .overlay(alignment: .trailing) {
            Button(action: onSwap) {
                Image("Сhange")
                    .resizable()
                    .frame(width: 36, height: 36)
            }
            .padding(.trailing, 16)
        }
    }
}
