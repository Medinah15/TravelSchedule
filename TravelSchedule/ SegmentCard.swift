//
//   SegmentCard.swift
//  TravelSchedule
//
//  Created by Medina Huseynova on 24.09.25.
//
import SwiftUI

// MARK: - View
struct SegmentCard: View {
    
    // MARK: - Properties
    let segment: Components.Schemas.Segment
    
    private var transportIcon: String {
        switch segment.thread?.transport_type {
        case "plane": return "airplane"
        case "train": return "train.side.front.car"
        case "suburban": return "tram.fill"
        case "bus": return "bus"
        case "water": return "ferry"
        case "helicopter": return "helicopter"
        default: return "questionmark.circle"
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(Color.clear)
                    if let logo = segment.thread?.carrier?.logo,
                       let url = URL(string: logo) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                        } placeholder: {
                            ProgressView().frame(width: 38, height: 38)
                        }
                    } else {
                        Image(systemName: transportIcon)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .frame(width: 38, height: 38)
                    }
                }
                .frame(width: 38, height: 38)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(segment.thread?.carrier?.title ?? "Без названия")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    
                    if let hasTransfers = segment.has_transfers, hasTransfers {
                        Text("С пересадкой")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
                
                if let dep = segment.departure {
                    Text(shortDateFormatter.string(from: dep))
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }
            }
            
            HStack {
                
                if let dep = segment.departure {
                    Text(timeFormatter.string(from: dep))
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                }
                
                ZStack {
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                    
                    if let duration = segment.duration {
                        Text(Self.formatDuration(duration))
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                if let arr = segment.arrival {
                    Text(timeFormatter.string(from: arr))
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                }
            }
            .frame(height: 40)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.15))
                .frame(height: 104)
        )
    }
    
    // MARK: - Helpers
    private static func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours) ч \(mins) мин" : "\(mins) мин"
    }
}

// MARK: - Formatters
fileprivate let shortDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ru_RU")
    f.setLocalizedDateFormatFromTemplate("d MMMM")
    return f
}()

fileprivate let timeFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "HH:mm"
    f.locale = Locale(identifier: "ru_RU")
    return f
}()
