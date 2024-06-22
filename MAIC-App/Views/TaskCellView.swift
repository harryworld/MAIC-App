//
//  TaskCellView.swift
//  MAIC-Tasks
//
//  Created by Harry Ng on 23/6/2024.
//
import SwiftUI
import SwiftData

enum TaskCellEvents {
    case onChecked(Task, Bool)
    case onSelect(Task)
}

struct TaskCellView: View {

    let task: Task
    let onEvent: (TaskCellEvents) -> Void
    @State private var checked: Bool = false

    private func formatTaskDate(_ date: Date) -> String {

        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }

    var body: some View {
        HStack(alignment: .top) {

            Image(systemName: checked ? "circle.inset.filled": "circle")
                .font(.title2)
                .padding([.trailing], 5)
                .onTapGesture {
                    checked.toggle()
                    onEvent(.onChecked(task, checked))
                }

            VStack {
                Text(task.title)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let notes = task.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack {

                    if let date = task.reminderDate {
                        Text(formatTaskDate(date))
                    }

                    if let time = task.reminderTime {
                        Text(time, style: .time)
                    }

                }
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvent(.onSelect(task))
        }
    }
}

struct TaskCellViewContainer: View {

    @Query(sort: \Task.title) private var tasks: [Task]

    var body: some View {
        TaskCellView(task: tasks[0]) { _ in

        }
    }
}

#Preview { @MainActor in
    TaskCellViewContainer()
        .modelContainer(previewContainer)
}
