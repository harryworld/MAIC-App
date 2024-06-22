//
//  TaskEditScreen.swift
//  MAIC-Tasks
//
//  Created by Harry Ng on 23/6/2024.
//

import SwiftUI
import SwiftData

struct TaskEditScreen: View {

    let task: Task

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var taskDate: Date = .now
    @State private var taskTime: Date = .now

    @State private var showCalender: Bool = false
    @State private var showTime: Bool = false

    private func updateTask() {
        task.title = title
        task.notes = notes.isEmpty ? nil: notes
        task.reminderDate = showCalender ? taskDate: nil
        task.reminderTime = showTime ? taskTime: nil
    }

    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Notes", text: $notes)
            }

            Section {

                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.title2)

                    Toggle(isOn: $showCalender) {
                        EmptyView()
                    }
                }

                if showCalender {

                    DatePicker("Select Date", selection: $taskDate, in: .now..., displayedComponents: .date)
                }

                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                        .font(.title2)
                    Toggle(isOn: $showTime) {
                        EmptyView()
                    }
                }
                .onChange(of: showTime) {
                    if showTime {
                        showCalender = true
                    }
                }

                if showTime {
                    DatePicker("Select Time", selection: $taskTime, displayedComponents: .hourAndMinute)
                }

            }

        }.onAppear(perform: {
            title = task.title
            notes = task.notes ?? ""
            taskDate = task.reminderDate ?? Date()
            taskTime = task.reminderTime ?? Date()
            showCalender = task.reminderDate != nil
            showTime = task.reminderTime != nil
        })
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    updateTask()
                    dismiss()
                }
                .disabled(!isFormValid)
            }
        }
    }
}

struct TaskEditScreenContainer: View {

    @Query(sort: \Task.title) private var tasks: [Task]

    var body: some View {
        TaskEditScreen(task: tasks[0])
    }
}

#Preview {
    NavigationStack {
        TaskEditScreenContainer()
    }.modelContainer(previewContainer)
}
