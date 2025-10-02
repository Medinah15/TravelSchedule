//
//  SearchResultsView.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 20.09.25.
import SwiftUI

// MARK: - View
struct SearchResultsView: View {
    
    let fromCode: String
    let toCode: String
    let fromTitle: String
    let toTitle: String
    
    @Binding var path: NavigationPath
    @StateObject private var viewModel = SearchResultsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    
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
        .task {
            await viewModel.loadResults(from: fromCode, to: toCode)
            if viewModel.filters != nil { viewModel.applyFilters(viewModel.filters) }
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
            ErrorView(type: appError.errorType)
            Spacer()
        } else if viewModel.displayedResults.isEmpty {
            Spacer()
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color("BlackUniversal"))
            Spacer()
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.displayedResults, id: \.thread?.uid) { segment in
                        SegmentCard(viewModel: SegmentViewModel(segment: segment))
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
        if !viewModel.originalResults.isEmpty {
            Button {
                path.append(Route.filters)
            } label: {
                HStack(spacing: 4) {
                    Text("Уточнить время")
                        .font(.system(size: 17, weight: .bold))
                    if viewModel.filtersApplied {
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
