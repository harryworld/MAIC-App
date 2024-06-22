import SwiftUI
import SwiftData

struct TaskListView: View {

    let tasks: [Task]
    @Environment(\.modelContext) private var context

    @State private var selectedTask: Task? = nil
    @State private var showTaskEditScreen: Bool = false

    @State private var taskIdAndDelay: [PersistentIdentifier: Delay] = [: ]

    private func deleteTask(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let task = tasks[index]
        context.delete(task)
    }

    var body: some View {
        List {
            ForEach(tasks) { task in
                TaskCellView(task: task) { event in
                    switch event {
                    case .onChecked(let task, let checked):

                        // get the delay from the dictionary
                        var delay = taskIdAndDelay[task.persistentModelID]
                            if let delay {
                                // cancel
                                delay.cancel()
                                taskIdAndDelay.removeValue(forKey: task.persistentModelID)

                            } else {
                                // create a new delay and add to the dictionary
                                delay = Delay()
                                taskIdAndDelay[task.persistentModelID] = delay
                                delay?.performWork {
                                    task.isCompleted = checked
                                }
                            }

                    case .onSelect(let task): // for editing
                        selectedTask = task
                    }
                }
            }
            .onDelete(perform: deleteTask)
        }
        .sheet(item: $selectedTask, content: { selectedTask in
            NavigationStack {
                TaskEditScreen(task: selectedTask)
            }
        })
    }
}

#Preview {
    TaskListView(tasks: SampleData.tasks)
}
