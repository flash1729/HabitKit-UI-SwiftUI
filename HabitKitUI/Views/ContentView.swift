import SwiftUI

struct ContentView: View {
    @StateObject private var habitViewModel = HabitsViewModel()
    @State private var showNewHabitSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(habitViewModel.habits) { habit in
                        HabitCardView(habit: habit, viewModel: habitViewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("HabitKit")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showNewHabitSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showNewHabitSheet) {
                NewHabitView(viewModel: habitViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
} 
