import Foundation

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var activeTimer: ActiveTimer = .work  // Change initial value from .none to .work
    
    private init() {}
}

enum ActiveTimer {
    case work
    case break_
    case none
}
