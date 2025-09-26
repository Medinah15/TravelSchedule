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
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(fromTitle) → \(toTitle)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("BlackUniversal"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загружаем рейсы…")
                Spacer()
            } else if viewModel.results.isEmpty {
                Spacer()
                Text("Вариантов нет")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("BlackUniversal"))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.results, id: \.thread?.uid) { segment in
                            SegmentCard(segment: segment)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 100)
                }
            }
            
            if !viewModel.results.isEmpty {
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
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        
        .toolbar {
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
        .toolbar(.hidden, for: .tabBar)  
        
        .navigationDestination(isPresented: $showFilters) {
            FiltersView()
                .toolbar(.hidden, for: .tabBar)
        }
        
        .task {
            await viewModel.loadResults(from: fromCode, to: toCode)
        }
    }
}
