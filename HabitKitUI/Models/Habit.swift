import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let color: Color
    let icon: String
    var completionData: [Date: Bool]  // Date: Completion Status (true/false)
    
    var isCompletedToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completionData[today] ?? false
    }
    
    // Add a method to mark a habit as complete for a specific date
    mutating func markComplete(for date: Date) {
        let dateKey = Calendar.current.startOfDay(for: date)
        completionData[dateKey] = true
    }
    
    // Add a method to mark a habit as incomplete for a specific date
    mutating func markIncomplete(for date: Date) {
        let dateKey = Calendar.current.startOfDay(for: date)
        completionData[dateKey] = false
        }
    
    init(title: String, description: String, color: Color, icon: String) {
        self.description = description
        self.color = color
        self.icon = icon
        self.completionData = (0..<60).map { _ in Bool.random() }
    }
} 
