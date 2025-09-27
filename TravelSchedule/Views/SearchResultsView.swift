//
//  SearchResultsView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.

import SwiftUI

// MARK: - View
struct SearchResultsView: View {
    
    // MARK: - Properties
    let fromCode: String
    let toCode: String
    
    let fromTitle: String
    let toTitle: String
    
    @Binding var path: NavigationPath
    @StateObject private var viewModel = SearchResultsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showFilters = false
    @State private var filtersApplied = false
    @State private var originalResults: [Components.Schemas.Segment] = []
    @State private var displayedResults: [Components.Schemas.Segment] = []
    @State private var filters: Filters?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
            filterButton
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar { backButton }
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $showFilters) {
            FiltersView { newFilters in
                self.filters = newFilters
                self.filtersApplied = true
                self.applyFilters()
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .task {
            await viewModel.loadResults(from: fromCode, to: toCode)
            originalResults = viewModel.results
            displayedResults = viewModel.results
            if filters != nil { applyFilters() }
        }
    }
}

// MARK: - Subviews
extension SearchResultsView {
    
    @ViewBuilder private var headerView: some View {
        HStack {
            Text("\(fromTitle) → \(toTitle)")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color("BlackUniversal"))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    @ViewBuilder private var contentView: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView("Загружаем рейсы…")
            Spacer()
        } else if let appError = viewModel.appError {
               Spacer()
               ErrorView(type: mapError(appError)) // ✅ показываем ошибку
               Spacer()
        } else if displayedResults.isEmpty {
            Spacer()
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color("BlackUniversal"))
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(displayedResults, id: \.thread?.uid) { segment in
                        SegmentCard(segment: segment)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let code = segment.thread?.carrier?.code {
                                    path.append(Route.carrierInfo(code: String(code)))
                                }
                            }
                        
                    }
                }
                .padding(16)
                .padding(.bottom, 100)
            }
        }
    }
    
    @ViewBuilder private var filterButton: some View {
        if !originalResults.isEmpty {
            Button { showFilters = true } label: {
                HStack(spacing: 4) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                    if filtersApplied {
                        Circle()
                            .fill(Color("RedUniversal"))
                            .frame(width: 8, height: 8)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 60)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color("WhiteUniversal"))
            .background(Color("BlueUniversal"))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }
    
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 22)
                    .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - Filtering
extension SearchResultsView {
    private func applyFilters() {
        guard let filters else {
            displayedResults = originalResults
            return
        }
        
        displayedResults = originalResults.filter { seg in
            
            if let hasTransfers = seg.has_transfers {
                if hasTransfers != filters.transfers { return false }
            } else {
                if filters.transfers != false { return false }
            }
            
            guard let dep = seg.departure else { return false }
            let h = Calendar.current.component(.hour, from: dep)
            
            var timeMatches = false
            if filters.morning { timeMatches = timeMatches || (h >= 6 && h < 12) }
            if filters.day     { timeMatches = timeMatches || (h >= 12 && h < 18) }
            if filters.evening { timeMatches = timeMatches || (h >= 18 && h < 24) }
            if filters.night   { timeMatches = timeMatches || (h >= 0 && h < 6) }
            
            return timeMatches
        }
    }
}
