//
//  MainView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
//
import SwiftUI

enum Route: Hashable {
    case cityPicker(isFrom: Bool)
    case stationPicker(cityId: String, cityTitle: String, isFrom: Bool)
    case searchResults(fromCode: String, toCode: String)
}

struct MainView: View {
    @State private var fromTitle = ""
    @State private var toTitle = ""
    
    @State private var fromStation: SelectedStation?
    @State private var toStation: SelectedStation?
    
    @State private var pickFrom = true
    
    @State private var path = NavigationPath()
    
    var canSearch: Bool { fromStation != nil && toStation != nil }
    
    var body: some View {
        NavigationStack(path: $path) {
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
                            path.append(Route.cityPicker(isFrom: true))
                        },
                        onToTap: {
                            pickFrom = false
                            path.append(Route.cityPicker(isFrom: false))
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 224)
                    
                    if canSearch {
                        NavigationLink(value: Route.searchResults(
                            fromCode: fromStation!.code,
                            toCode: toStation!.code
                        )) {
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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .cityPicker(let isFrom):
                    CityPickerView { city in
                        path.removeLast()
                        path.append(Route.stationPicker(
                            cityId: city.id,
                            cityTitle: city.title,
                            isFrom: isFrom
                        ))
                    }
                    .toolbar(.hidden, for: .tabBar)
                    
                case .stationPicker(let cityId, let cityTitle, let isFrom):
                    StationPickerView(cityId: cityId) { station in
                        let combinedTitle = "\(cityTitle) (\(station.title))"
                        if isFrom {
                            fromStation = station
                            fromTitle = combinedTitle
                        } else {
                            toStation = station
                            toTitle = combinedTitle
                        }
                        path.removeLast()
                    }
                    .toolbar(.hidden, for: .tabBar)
                    
                case .searchResults(let fromCode, let toCode):
                    SearchResultsView(from: fromCode, to: toCode)
                }
            }
        }
    }
}
