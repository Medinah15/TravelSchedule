//
//  MainView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
//
import SwiftUI

struct MainView: View {
    // MARK: - State
    
    @State private var fromTitle = ""
    @State private var toTitle = ""
    
    @State private var fromStation: SelectedStation?
    @State private var toStation: SelectedStation?
    
    @State private var showFromSearch = false
    @State private var showToSearch = false
    
    @State private var pickFrom = true
    @State private var selectedCity = ""
    
    var canSearch: Bool { fromStation != nil && toStation != nil }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    SearchPanel(
                        from: $fromTitle,
                        to: $toTitle,
                        onSwap: {
                            swap(&fromTitle, &toTitle)
                            swap(&fromStation, &toStation)
                        },
                        onFromTap: {
                            pickFrom = true
                            showFromSearch = true
                        },
                        onToTap: {
                            pickFrom = false
                            showToSearch = true
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 224)
                    
                    if canSearch {
                        NavigationLink {
                            SearchResultsView(
                                from: fromStation!.code,
                                to: toStation!.code
                            )
                        } label: {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .frame(width: 150, height: 60)
                                .background(Color(red: 55/255, green: 114/255, blue: 231/255))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                    
                    Spacer()
                }
            }
            
            .navigationDestination(isPresented: $showFromSearch) {
                CityPickerView { city in
                    selectedCity = city
                    showFromSearch = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showStationPicker(for: city, isFrom: true)
                    }
                }
                .toolbar(.hidden, for: .tabBar)
            }
            
            .navigationDestination(isPresented: $showToSearch) {
                CityPickerView { city in
                    selectedCity = city
                    showToSearch = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showStationPicker(for: city, isFrom: false)
                    }
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func showStationPicker(for city: String, isFrom: Bool) {
        
    }
}
