//
//  NewHabitView.swift
//  HabitlKit UI
//
//  Created by Aditya Medhane on 02/11/24.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HabitsViewModel
    
    @State private var habitName: String = ""
    @State private var habitDescription: String = ""
    @State private var streakGoal: Int = 2
    @State private var reminder: Date = Date()
    @State private var selectedIcon: String = "book.fill"
    @State private var selectedColor: Color = .blue
    
    let icons = [
        "waveform.path.ecg", "alarm", "apple.logo", "bed.double.fill",
        "calendar", "heart.circle", "snow", "dumbbell.fill",
        "doc.fill", "figure.walk", "leaf.fill", "yinyang",
        "music.note", "flag.fill", "list.bullet", "apple.logo",
        "dollarsign", "heart.fill", "leaf", "gamecontroller",
        "car.fill"
    ]
        
    let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink,
        .teal, .cyan, .indigo, .mint, .brown, .gray
    ]
    
    var body: some View {
           NavigationView {
               Form {
                   Section(header: Text("Habit Details")) {
                       TextField("Name", text: $habitName)
                       TextField("Description", text: $habitDescription)
                   }
                   
                   Section(header: Text("Goal")) {
                       Stepper(value: $streakGoal, in: 1...7) {
                           Text("\(streakGoal) / Week")
                       }
                   }
                   
                   Section(header: Text("Reminder")) {
                       DatePicker("Time", selection: $reminder, displayedComponents: .hourAndMinute)
                   }
                   
                   Section(header: Text("Icon")) {
                       LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                           ForEach(icons, id: \.self) { icon in
                               Image(systemName: icon)
                                   .font(.title2)
                                   .frame(width: 44, height: 44)
                                   .background(selectedIcon == icon ? Color.gray.opacity(0.3) : Color.clear)
                                   .cornerRadius(8)
                                   .onTapGesture {
                                       selectedIcon = icon
                                   }
                           }
                       }
                       .padding(.vertical, 8)
                   }
                   
                   Section(header: Text("Color")) {
                       LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                           ForEach(colors, id: \.self) { color in
                               Circle()
                                   .fill(color)
                                   .frame(width: 30, height: 30)
                                   .overlay(
                                       Circle()
                                           .stroke(Color.white, lineWidth: selectedColor == color ? 2 : 0)
                                   )
                                   .onTapGesture {
                                       selectedColor = color
                                   }
                           }
                       }
                       .padding(.vertical, 8)
                   }
               }
               .navigationTitle("New Habit")
               .toolbar {
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button(action: {
                           dismiss()
                       }) {
                           Text("Cancel")
                       }
                   }
                   
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button(action: {
                           let newHabit = Habit(title: habitName, description: habitDescription, color: selectedColor, icon: selectedIcon)
                           
                           print("--- New Habit Creation Log ---")
                           print("Creating habit with parameters:")
                           print("Title: \(habitName)")
                           print("Description: \(habitDescription)")
                           print("Icon: \(selectedIcon)")
                           print("Color: \(selectedColor)")
                           print("Streak Goal: \(streakGoal)")
                           print("Reminder Time: \(reminder)")
                           
                           viewModel.addHabit(newHabit)
                           
                           print("\nCurrent habits in array:")
                           viewModel.habits.forEach { habit in
                               print("- \(habit.title)")
                           }
                           print("------------------------\n")
                           
                           dismiss()
                       }) {
                           Text("Save")
                       }
                       .disabled(habitName.isEmpty)
                   }
               }
           }
       }
}

#Preview {
    let viewModel = HabitsViewModel()
    NewHabitView(viewModel: viewModel)
}
