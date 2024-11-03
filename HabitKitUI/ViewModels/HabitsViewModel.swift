import SwiftUI
import Foundation

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit]
    
    init() {
        self.habits = [
            Habit(title: "Meditation", description: "Meditate daily for 15 minutes", color: Color.purple, icon: "brain.head.profile"),
            Habit(title: "Exercise", description: "30 minutes workout", color: Color.orange, icon: "figure.run"),
            Habit(title: "Reading", description: "Read everyday for at least 15 minutes", color: Color.blue, icon: "book.fill"),
            Habit(title: "Coding", description: "Practice coding skills", color: Color.green, icon: "chevron.left.forwardslash.chevron.right")
        ]
    }
    
    func addHabit(_ habit: Habit) {
        habits.insert(habit, at: 0)
        objectWillChange.send()
    }
    
    func toggleHabit(habitId: UUID, dayIndex: Int) {
            if let habitIndex = habits.firstIndex(where: { $0.id == habitId }) {
                guard dayIndex >= 0 && dayIndex < habits[habitIndex].completionData.count else { return }
                habits[habitIndex].completionData[dayIndex].toggle()
            }
    }
}

