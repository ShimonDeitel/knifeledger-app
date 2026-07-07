import Foundation

struct KnifeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var lastSharpened: String
    var steelType: String
    var notes: String

    init(id: UUID = UUID(), name: String = "", lastSharpened: String = "", steelType: String = "", notes: String = "") {
        self.id = id
        self.name = name
        self.lastSharpened = lastSharpened
        self.steelType = steelType
        self.notes = notes
    }
}
