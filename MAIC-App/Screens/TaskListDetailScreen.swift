import SwiftUI
import SwiftData

struct TaskListDetailScreen: View {

    let taskList: TaskList
    @Query private var tasks: [Task]

    @State private var title: String = ""
    @State private var isNewTaskPresented: Bool = false

    @State private var selectedTask: Task?
    @State private var showTaskEditScreen: Bool = false

    @Environment(\.modelContext) private var context

    init(taskList: TaskList) {

        self.taskList = taskList

        let listId = taskList.persistentModelID

        let predicate = #Predicate<Task> { task in
            task.list?.persistentModelID == listId
            && !task.isCompleted
        }

        _tasks = Query(filter: predicate)
    }

    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }

    private func saveTask() {
        let task = Task(title: title)
        taskList.tasks?.append(task)
    }

    private func isTaskSelected(_ task: Task) -> Bool {
        task.persistentModelID == selectedTask?.persistentModelID
    }

    private func deleteTask(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        guard let task = taskList.tasks?[index] else { return }

        context.delete(task)
    }

    var body: some View {
        VStack {

            TaskListView(tasks: tasks)

            Spacer()
            Button(action: {
                isNewTaskPresented = true
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Task")
                }
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

        }
        .alert("New Task", isPresented: $isNewTaskPresented) {
            TextField("", text: $title)
            Button("Cancel", role: .cancel) { }
            Button("Done") {
                if isFormValid {
                    saveTask()
                    title = ""
                }
            }
        }
        .navigationTitle(taskList.name)
        .sheet(isPresented: $showTaskEditScreen, content: {
            if let selectedTask {
                NavigationStack {
                    TaskEditScreen(task: selectedTask)
                }
            }
        })
    }
}
