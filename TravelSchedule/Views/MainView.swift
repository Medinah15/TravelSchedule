//
//  MainView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 19.09.25.
//
import SwiftUI

// MARK: - View
struct MainView: View {
    
    // MARK: - State
    @State private var fromTitle = ""
    @State private var toTitle = ""
    
    @State private var fromStation: SelectedStation?
    @State private var toStation: SelectedStation?
    
    @State private var pickFrom = true
    @State private var path = NavigationPath()
    
    // Stories
    @State private var stories: [Story] = [
        Story(imageName: "story1",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story2",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story3",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story4",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story5",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story6",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story7",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false)
    ]
    @State private var showStories = false
    @State private var selectedIndex = 0
    
    // MARK: - Computed
    var canSearch: Bool { fromStation != nil && toStation != nil }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 24) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(stories.indices, id: \.self) { index in
                                Button {
                                    selectedIndex = index
                                    showStories = true
                                } label: {
                                    StoriesRow(story: stories[index])
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                    
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
                    .padding(.top, 24)
                    
                    if canSearch {
                        NavigationLink(value: Route.searchResults(
                            fromCode: fromStation!.code,
                            toCode: toStation!.code,
                            fromTitle: fromStation!.title,
                            toTitle: toStation!.title
                        )) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .frame(width: 150, height: 60)
                                .background(Color("BlueUniversal"))
                                .foregroundStyle(Color("WhiteUniversal"))
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
                        if isFrom {
                            fromStation = station
                            fromTitle = "\(cityTitle), \(station.title)"
                        } else {
                            toStation = station
                            toTitle = "\(cityTitle), \(station.title)"
                        }
                        path.removeLast()
                    }
                    .toolbar(.hidden, for: .tabBar)
                    
                case .searchResults(let fromCode, let toCode, let fromTitle, let toTitle):
                    SearchResultsView(
                        fromCode: fromCode,
                        toCode: toCode,
                        fromTitle: fromTitle,
                        toTitle: toTitle,
                        path: $path
                    )
                    .toolbar(.hidden, for: .tabBar)
                    
                case .carrierInfo(let code):
                    CarrierCardView(carrierCode: code)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            
            .fullScreenCover(isPresented: $showStories) {
                StoriesView(stories: $stories, selectedIndex: $selectedIndex)
            }
        }
    }
}
