import SwiftUI
import SwiftData

enum TaskStatsType: Int, Identifiable {

    case today
        case scheduled
        case all
        case completed

    var id: Int {
        self.rawValue
    }

    var title: String {
        switch self {
            case .today:
                return "Today"
            case .scheduled:
                return "Scheduled"
            case .all:
                return "All"
            case .completed:
                return "Completed"
        }
    }
}

struct TaskListsScreen: View {

    @Environment(\.modelContext) private var context

    @Query private var taskLists: [TaskList]
    @State private var isPresented: Bool = false
    @State private var selectedList: TaskList?

    @State private var actionSheet: TaskListScreenSheets?
    @Query private var tasks: [Task]
    @State private var TaskStatsType: TaskStatsType?

    @State private var search: String = ""
    @Environment(\.colorScheme) private var colorScheme

    enum TaskListScreenSheets: Identifiable {

        case newList
        case editList(TaskList)

        var id: Int {
            switch self {
                case .newList:
                    return 1
                case .editList(let TaskList):
                    return TaskList.hashValue
            }
        }
    }

    private var inCompleteTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }

    private var todaysTasks: [Task] {
           tasks.filter {
               guard let date = $0.reminderDate else {
                   return false
               }

               return date.isToday && !$0.isCompleted
           }
    }

    private var scheduledTasks: [Task] {
        tasks.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }

    private var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }

    private var searchResults: [Task] {
        tasks.filter {
            $0.title.lowercased().contains(search.lowercased()) &&
            !$0.isCompleted
        }
    }

    private func tasks(for type: TaskStatsType) -> [Task] {
        switch type {
            case .all:
                return inCompleteTasks
            case .scheduled:
                return scheduledTasks
            case .today:
                return todaysTasks
            case .completed:
                return completedTasks
        }
    }

    private func deleteList(indexSet: IndexSet) {

        guard let index = indexSet.first else { return }
        let TaskList = taskLists[index]

        // delete it
        context.delete(TaskList)
    }

    var body: some View {
        List {
            // TODO: Stats View

            ForEach(taskLists) { list in
                NavigationLink(value: list) {
                    TaskListCellView(taskList: list)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedList = list
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            actionSheet = .editList(list)
                        }
                }
            }
            // TODO: Delete list

            Button(action: {
                actionSheet = .newList
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
            .listRowSeparator(.hidden)

        }
        // TODO: Search
        .navigationTitle("My Lists")
        .navigationDestination(item: $selectedList, destination: { taskList in
            // TODO: Navigation to List Detail
        })
        .navigationDestination(item: $TaskStatsType, destination: { taskStatsType in
            NavigationStack {
               // TODO: Navigation to Stats
            }
        })

        .listStyle(.plain)
        .sheet(item: $actionSheet) { actionSheet in
            switch actionSheet {
                case .newList:
                    NavigationStack {
                        // TODO: Add Task List
                    }
                case .editList(let taskList):
                    NavigationStack {
                        // TODO: Edit Task List
                    }
            }
        }
    }
}

#Preview("Light Mode") { @MainActor in
    NavigationStack {
        TaskListsScreen()
    }
    .modelContainer(previewContainer)
}

#Preview("Dark Mode") { @MainActor in
    NavigationStack {
        TaskListsScreen()
    }
    .modelContainer(previewContainer)
    .environment(\.colorScheme, .dark)
}


