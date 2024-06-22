import SwiftUI

struct TaskListCellView: View {

    let taskList: TaskList

    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color(hex: taskList.colorCode))
            Text(taskList.name)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
