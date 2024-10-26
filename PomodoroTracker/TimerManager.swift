import Foundation

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var activeTimer: ActiveTimer = .work
    
    private init() {}
    
    func handleSwipeUp() {
        activeTimer = .break_
    }
    
    func handleSwipeDown() {
        activeTimer = .work
    }
}

enum ActiveTimer {
    case work
    case break_
    case none
}
