import Foundation
import SwiftData

@Model
class TaskList {

    var name: String = ""
    var colorCode: String = "#34C759"

    @Relationship(deleteRule: .cascade)
    var tasks: [Task]?

    init(name: String, colorCode: String) {
        self.name = name
        self.colorCode = colorCode
    }
}
