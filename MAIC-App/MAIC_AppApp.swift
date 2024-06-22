//
//  MAIC_AppApp.swift
//  MAIC-App
//
//  Created by Harry Ng on 23/6/2024.
//

import SwiftUI

@main
struct MAIC_AppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskListsScreen()
            }
            .modelContainer(for: TaskList.self)
        }
    }
}
