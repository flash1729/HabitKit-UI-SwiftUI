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
    
    var body: some View {\n        ScrollViewReader { proxy in\n            ScrollView(.horizontal, showsIndicators: false) {\n                HStack(spacing: spacing) {\n                    ForEach(0..<weeks, id: \\.self) { weekIndex in\n                        VStack(spacing: spacing) {\n                            ForEach(0..<daysInWeek, id: \\.self) { dayInWeek in\n                                let currentDate = Calendar.current.date(byAdding: .day, value: weekIndex * daysInWeek + dayInWeek, to: startDate)!\n                                let isCompleted = habit.completionData[currentDate] ?? false\n                                \n                                DayCell(\n                                    color: habit.color,\n                                    isCompleted: isCompleted,\n                                    isToday: Calendar.current.isDateInToday(currentDate),\n                                    date: currentDate\n                                )\n                                .frame(width: squareSize, height: squareSize)\n                            }\n                        }\n                    }\n                }\n                .padding(.horizontal, 8)\n            }\n            .frame(height: (squareSize * CGFloat(daysInWeek)) + (spacing * CGFloat(daysInWeek - 1)))\n            .onAppear {\n                // Scroll to the end (most recent week) when view appears\n                withAnimation {\n                    proxy.scrollTo(weeks - 1, anchor: .trailing)\n                }\n            }\n        }\n    }\n}\n\nstruct DayCell: View {\n    let color: Color\n    let isCompleted: Bool\n    let isToday: Bool\n    let date: Date\n    \n    @State private var isHovered = false\n    \n    var body: some View {\n        ZStack {\n            Rectangle()\n                .fill(isCompleted ? color : color.opacity(0.15))\n                .cornerRadius(4)\n                .overlay(\n                    isToday ?\n                        RoundedRectangle(cornerRadius: 4)\n                            .stroke(color, lineWidth: 2)\n                        : nil\n                )\n                .overlay(\n                    isHovered ?\n                        DateTooltip(date: date, isCompleted: isCompleted)\n                            .offset(y: -25)\n                        : nil\n                )\n        }\n        .onHover { hovering in\n            isHovered = hovering\n        }\n    }\n}\n\nstruct DateTooltip: View {\n    let date: Date\n    let isCompleted: Bool\n    \n    var body: some View {\n        VStack(spacing: 2) {\n            Text(date.formatted(.dateTime.month().day()))\n                .font(.caption2)\n            Text(isCompleted ? "Completed" : "Not completed")\n                .font(.caption2)\n        }\n        .padding(4)\n        .background(Color.gray.opacity(0.9))\n        .foregroundColor(.white)\n        .cornerRadius(4)\n    }\n}\n\n#Preview {\n    let viewModel = HabitsViewModel()\n    return HabitGridView(habit: viewModel.habits[0])\n        .padding()\n}\n
