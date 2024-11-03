import SwiftUI

struct HabitGridView: View {
    let habit: Habit
    private let calendar = Calendar.current
    
    // Constants for grid layout
    private let squareSize: CGFloat = 16
    private let spacing: CGFloat = 2
    private let daysInWeek = 7
    
    // Computed properties for grid layout
    private var startDate: Date {
        // Get date from 150 days ago
        calendar.date(byAdding: .day, value: -149, to: Date()) ?? Date()
    }
    
    private var weeks: Int {
        // Calculate number of weeks needed to display 150 days
        22 // Approximately 150/7 rounded up
    }
    
    // Get weekday number (1-7) for the current date
    private var currentWeekday: Int {
        let weekday = calendar.component(.weekday, from: Date())
        // Convert to 0-6 range where 0 is Monday
        return (weekday + 5) % 7
    }
    
    private func dayIndex(weekIndex: Int, dayInWeek: Int) -> Int? {
        let totalDays = weekIndex * daysInWeek + dayInWeek
        // Return nil if we're beyond today's date
        guard totalDays <= 149 else { return nil }
        return totalDays
    }
    
    private func isToday(weekIndex: Int, dayInWeek: Int) -> Bool {
        guard let index = dayIndex(weekIndex: weekIndex, dayInWeek: dayInWeek) else { return false }
        return index == 149 // Last day in the range
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(0..<weeks, id: \.self) { weekIndex in
                        VStack(spacing: spacing) {
                            ForEach(0..<daysInWeek, id: \.self) { dayInWeek in
                                if let index = dayIndex(weekIndex: weekIndex, dayInWeek: dayInWeek) {
                                    let isCompleted = index < habit.completionData.count && habit.completionData[index]
                                    DayCell(
                                        color: habit.color,
                                        isCompleted: isCompleted,
                                        isToday: isToday(weekIndex: weekIndex, dayInWeek: dayInWeek),
                                        date: calendar.date(byAdding: .day, value: index, to: startDate) ?? Date()
                                    )
                                    .frame(width: squareSize, height: squareSize)
                                } else {
                                    Color.clear
                                        .frame(width: squareSize, height: squareSize)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: (squareSize * CGFloat(daysInWeek)) + (spacing * CGFloat(daysInWeek - 1)))
            .onAppear {
                // Scroll to the end (most recent week) when view appears
                withAnimation {
                    proxy.scrollTo(weeks - 1, anchor: .trailing)
                }
            }
        }
    }
}

struct DayCell: View {
    let color: Color
    let isCompleted: Bool
    let isToday: Bool
    let date: Date
    
    @State private var isHovered = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isCompleted ? color : color.opacity(0.15))
                .cornerRadius(4)
                .overlay(
                    isToday ?
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(color, lineWidth: 2)
                        : nil
                )
                .overlay(
                    isHovered ?
                        DateTooltip(date: date, isCompleted: isCompleted)
                            .offset(y: -25)
                        : nil
                )
        }
    }
}

struct DateTooltip: View {
    let date: Date
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Text(date.formatted(.dateTime.month().day()))
                .font(.caption2)
            Text(isCompleted ? "Completed" : "Not completed")
                .font(.caption2)
        }
        .padding(4)
        .background(Color.gray.opacity(0.9))
        .foregroundColor(.white)
        .cornerRadius(4)
    }
}

#Preview {
    let viewModel = HabitsViewModel()
    HabitGridView(habit: viewModel.habits[0])
        .padding()
}
