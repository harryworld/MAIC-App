import SwiftUI

struct AddTaskListScreen: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var color: Color = .blue
    @State private var listName: String = ""

    var taskList: TaskList? = nil

    var body: some View {
        VStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(color)

            TextField("List name", text: $listName)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 44)

            // TODO: Color Picker
        }
        .onAppear(perform: {
            if let taskList {
                listName = taskList.name
                color = Color(hex: taskList.colorCode)
            }
        })
        .navigationTitle(taskList == nil ? "New List": "Edit List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {

                    if let taskList {
                        taskList.name = listName
                        taskList.colorCode = color.toHex() ?? ""
                    } else {
                        guard let hex = color.toHex() else { return }
                        let taskList = TaskList(name: listName, colorCode: hex)
                        context.insert(taskList)
                    }

                    dismiss()
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddTaskListScreen()
    }
    .modelContainer(previewContainer)
}
