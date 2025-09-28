//
//  Story.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//


import SwiftUI

    // MARK: - Story

class Story: Identifiable, ObservableObject {

    // MARK: - Published
    @Published var isViewed: Bool
    
    // MARK: - Constants

    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    
    // MARK: - Init

    init(imageName: String, title: String, subtitle: String, isViewed: Bool) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.isViewed = isViewed
    }
}
