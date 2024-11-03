import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let color: Color
    let icon: String
    var completionData: [Bool]
    
    var isCompletedToday: Bool {
            // Assuming the last element in completionData represents today
            completionData.last ?? false
        }
    
    init(title: String, description: String, color: Color, icon: String) {
        self.title = title
        self.description = description
        self.color = color
        self.icon = icon
        self.completionData = (0..<60).map { _ in Bool.random() }
    }
} 
