//
//  Story.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//

import SwiftUI

class Story: Identifiable, ObservableObject {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    @Published var isViewed: Bool
    
    init(imageName: String, title: String, subtitle: String, isViewed: Bool) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.isViewed = isViewed
    }
}
