//
//  StatsView.swift
//  DreamLog
//

import Charts
import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: DreamLogViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Statistics")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.horizontal)
                        .padding(.top, 8)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCard(
                            title: "Total dreams",
                            value: "\(viewModel.totalDreams)",
                            icon: "moon.stars",
                            color: .dreamLucid,
                            cardColor: .dreamMystic.opacity(0.2)
                        )
                        StatCard(
                            title: "Lucid",
                            value: "\(viewModel.lucidCount)",
                            icon: "sparkles",
                            color: .dreamLucid,
                            cardColor: .dreamMystic.opacity(0.2)
                        )
                        StatCard(
                            title: "Nightmares",
                            value: "\(viewModel.nightmareCount)",
                            icon: "cloud.bolt",
                            color: .dreamMystic,
                            cardColor: .dreamMystic.opacity(0.2)
                        )
                        StatCard(
                            title: "Recall",
                            value: String(format: "%.0f%%", viewModel.recallRate),
                            icon: "brain",
                            color: .dreamLucid,
                            cardColor: .dreamMystic.opacity(0.2)
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dreams by month")
                            .font(.headline)
                            .foregroundColor(.dreamLucid)
                        if viewModel.monthlyDreams.isEmpty {
                            Text("Log a dream to see the chart.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Chart {
                                ForEach(viewModel.monthlyDreams) { data in
                                    BarMark(
                                        x: .value("Month", data.month),
                                        y: .value("Count", data.count)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.55)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                            }
                            .frame(height: 150)
                        }
                    }
                    .padding(16)
                    .dreamDeepPanel(cornerRadius: 16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dream types")
                            .font(.headline)
                            .foregroundColor(.dreamLucid)
                        if viewModel.typeDistribution.isEmpty {
                            Text("No data yet.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.typeDistribution) { item in
                                HStack {
                                    Image(systemName: item.icon)
                                        .foregroundColor(item.color)
                                        .frame(width: 30)
                                    Text(item.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(item.count)")
                                        .foregroundColor(item.color)
                                    Text("(\(Int(item.percentage))%)")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(16)
                    .dreamDeepPanel(cornerRadius: 16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top emotions")
                            .font(.headline)
                            .foregroundColor(.dreamLucid)
                        if viewModel.topEmotions.isEmpty {
                            Text("Add emotions to dreams to see trends.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.topEmotions) { emotion in
                                HStack {
                                    Image(systemName: emotion.icon)
                                        .foregroundColor(.dreamLucid)
                                        .frame(width: 30)
                                    Text(emotion.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(emotion.count)×")
                                        .foregroundColor(.dreamLucid)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(16)
                    .dreamDeepPanel(cornerRadius: 16)
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .dreamScreenBackdrop()
        }
        .background(Color.clear)
    }
}
