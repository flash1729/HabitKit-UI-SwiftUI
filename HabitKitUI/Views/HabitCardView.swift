import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: habit.icon)
                    .font(.title2)
                    .foregroundColor(habit.color)
                
                VStack(alignment: .leading) {
                    Text(habit.title)
                        .font(.headline)
                    Text(habit.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    viewModel.toggleHabit(habitId: habit.id, dayIndex: habit.completionData.count - 1)
                                }
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(habit.color)
                                    .opacity(habit.isCompletedToday ? 1.0 : 0.2)
                                    .scaleEffect(habit.isCompletedToday ? 1.1 : 1.0)
                                    .font(.system(size: 24))
                                    .contentShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sensoryFeedback(.impact(weight: .medium), trigger: habit.isCompletedToday)
            }
            
            HabitGridView(habit: habit)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

#Preview {
    let viewModel = HabitsViewModel()
    HabitCardView(habit: viewModel.habits[0], viewModel: viewModel)
        .padding()
}
