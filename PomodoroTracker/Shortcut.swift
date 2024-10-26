import SwiftUI

enum ShortcutMode {
    case counter
    case extraCounter
}

struct Shortcut: Identifiable {
    let id: UUID
    let value: Int
    
    init(value: Int) {
        self.id = UUID()
        self.value = value
    }
}
