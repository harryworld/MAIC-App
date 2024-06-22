//
//  PreviewContainer.swift
//  MAIC-Reminders
//
//  Created by Harry Ng on 23/6/2024.
//

import Foundation
import SwiftData

@MainActor
var previewContainer: ModelContainer = {

    let container = try! ModelContainer(for: TaskList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    for taskList in SampleData.taskLists {
        container.mainContext.insert(taskList)
        taskList.tasks = SampleData.tasks
    }

    return container

}()

struct SampleData {

    static var taskLists: [TaskList] {
        return [TaskList(name: "Reminders", colorCode: "#34C759"), TaskList(name: "Backlog", colorCode: "#AF52DE")]
    }

    static var tasks: [Task] {
        return [Task(title: "Reminder 1", notes: "This is reminder 1 notes!", reminderDate: Date(), remminderTime: Date()), Task(title: "Reminder 2", notes: "This is a reminder 2 note")]
    }
}
