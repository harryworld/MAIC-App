import Foundation
import SwiftData

@Model
class Task {

    var title: String = ""
    var notes: String?
    var isCompleted: Bool = false
    var reminderDate: Date?
    var reminderTime: Date?

    var list: TaskList?

    init(
        title: String,
        notes: String? = nil,
        isCompleted: Bool = false,
        reminderDate: Date? = nil,
        remminderTime: Date? = nil,
        list: TaskList? = nil
    ) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
        self.reminderTime = remminderTime
        self.list = list
    }
}
