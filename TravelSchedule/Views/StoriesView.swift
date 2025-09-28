//
//  StoriesView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 27.09.25.
//
import SwiftUI

struct StoriesView: View {
    @Binding var stories: [Story]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    private let storyDuration: TimeInterval = 3.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            TabView(selection: $selectedIndex) {
                ForEach(stories.indices, id: \.self) { index in
                    StoryPageView(
                        story: stories[index],
                        index: index,
                        selectedIndex: selectedIndex,
                        progress: progress
                    )
                    .tag(index)
                    .onAppear {
                        stories[index].isViewed = true
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onChange(of: selectedIndex) { _ in
            startTimer()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { t in
            progress += 0.03 / storyDuration
            if progress >= 1.0 {
                progress = 0.0
                if selectedIndex < stories.count - 1 {
                    selectedIndex += 1
                } else {
                    t.invalidate()
                    dismiss()
                }
            }
        }
    }
}
