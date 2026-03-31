//
//  CalendarView.swift
//  DreamLog
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: DreamLogViewModel
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date? = Date()
    @State private var showAddDream = false
    @State private var selectedDream: Dream?
    @State private var dreamToEdit: Dream?

    private let calendar = Calendar.current

    private var monthYearString: String {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        f.locale = Locale(identifier: "en_US")
        return f.string(from: displayedMonth)
    }

    private func daysInMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))
        else { return [] }
        let weekdayIndex = calendar.component(.weekday, from: firstOfMonth)
        let pad = (weekdayIndex - calendar.firstWeekday + 7) % 7
        var days: [Date?] = Array(repeating: nil, count: pad)
        for day in range {
            if let d = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(d)
            }
        }
        while days.count % 7 != 0 {
            days.append(nil)
        }
        return days
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return (0..<7).map { symbols[($0 + first) % 7] }
    }

    private func previousMonth() {
        if let d = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = d
        }
    }

    private func nextMonth() {
        if let d = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = d
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your journey")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.dreamLucid, Color.dreamLucid.opacity(0.72)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Text("\(MoonPhaseHelper.greeting()) · \(MoonPhaseHelper.label())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("New / quarter / full days are marked under each date. Add a dream with + to see features.")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            StatCard(
                                title: "Total dreams",
                                value: "\(viewModel.totalDreams)",
                                icon: "moon.stars",
                                color: .dreamLucid,
                                cardColor: .dreamMystic.opacity(0.2)
                            )
                            .frame(width: 140, alignment: .leading)
                            StatCard(
                                title: "Lucid",
                                value: "\(viewModel.lucidCount)",
                                icon: "sparkles",
                                color: .dreamLucid,
                                cardColor: .dreamMystic.opacity(0.2)
                            )
                            .frame(width: 140, alignment: .leading)
                            StatCard(
                                title: "This month",
                                value: "\(viewModel.monthlyCount)",
                                icon: "calendar",
                                color: .dreamLucid,
                                cardColor: .dreamMystic.opacity(0.2)
                            )
                            .frame(width: 140, alignment: .leading)
                            StatCard(
                                title: "Streak",
                                value: "\(viewModel.streakDays)",
                                icon: "flame.fill",
                                color: .dreamLucid,
                                cardColor: .dreamMystic.opacity(0.2)
                            )
                            .frame(width: 140, alignment: .leading)
                        }
                        .padding(.vertical, 4)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)

                    VStack(spacing: 12) {
                        HStack {
                            Button(action: previousMonth) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.dreamMystic)
                            }
                            Spacer()
                            Text(monthYearString)
                                .font(.title2)
                                .foregroundColor(.dreamLucid)
                            Spacer()
                            Button(action: nextMonth) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.dreamMystic)
                            }
                        }
                        HStack {
                            ForEach(weekdaySymbols, id: \.self) { day in
                                Text(day)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                        lunarLegend
                        Text("Below each number: dream dot (if any), then moon phase for that day.")
                            .font(.caption2)
                            .foregroundColor(.dreamLucid.opacity(0.75))
                        calendarGrid(days: daysInMonth())
                    }
                    .padding()
                    .dreamDeepPanel(cornerRadius: 18)
                    .padding(.horizontal, 16)

                    if let selectedDate {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(sectionDateTitle(selectedDate))
                                .font(.headline)
                                .foregroundColor(.dreamLucid)
                                .padding(.horizontal, 16)

                            ForEach(viewModel.dreamsOnDate(selectedDate)) { dream in
                                DreamCard(dream: dream)
                                    .contentShape(Rectangle())
                                    .onTapGesture { selectedDream = dream }
                                    .contextMenu {
                                        Button {
                                            viewModel.toggleFavorite(dream)
                                        } label: {
                                            Label("Favorite", systemImage: "star")
                                        }
                                        Button(role: .destructive) {
                                            viewModel.deleteDream(dream)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 88)
                    }
                }
                .padding(.vertical, 12)
            }
            .dreamScreenBackdrop()

            Button {
                showAddDream = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 56))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color.dreamLucid)
            }
            .dreamFloatingButtonShadow()
            .padding(24)
            .accessibilityLabel("Add dream")
        }
        .background(Color.clear)
        .sheet(isPresented: $showAddDream) {
            AddDreamView(
                viewModel: viewModel,
                defaultDate: selectedDate ?? Date()
            )
        }
        .sheet(item: $selectedDream) { dream in
            DreamDetailView(
                dream: dream,
                viewModel: viewModel,
                onEdit: {
                    dreamToEdit = dream
                }
            )
        }
        .sheet(item: $dreamToEdit) { dream in
            EditDreamView(viewModel: viewModel, dream: dream)
        }
    }

    @ViewBuilder
    private func calendarGrid(days: [Date?]) -> some View {
        let rows = stride(from: 0, to: days.count, by: 7).map { rowStart in
            Array(days[rowStart..<min(rowStart + 7, days.count)])
        }
        VStack(spacing: 6) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 4) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, cell in
                        Group {
                            if let date = cell {
                                DayCell(
                                    date: date,
                                    hasDream: viewModel.hasDream(on: date),
                                    dreamType: viewModel.dreamType(on: date),
                                    isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false,
                                    lunarMark: MoonPhaseHelper.lunarMark(forCalendarDay: date)
                                )
                                .onTapGesture { selectedDate = date }
                            } else {
                                Color.clear
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    private func sectionDateTitle(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        f.locale = Locale(identifier: "en_US")
        return f.string(from: date)
    }

    private var lunarLegend: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Moon calendar (approximate)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.dreamLucid)
            HStack(spacing: 12) {
                ForEach(MoonPhaseHelper.LunarMark.calendarLegendCases, id: \.self) { mark in
                    HStack(spacing: 6) {
                        LunarPhaseGlyph(mark: mark)
                            .frame(width: 14, height: 14)
                        Text(mark.shortLabel)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.75))
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
}
