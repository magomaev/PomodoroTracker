import SwiftUI

struct AppVariables {
    /* Animation */
    static let defaultAnimation: Animation = .easeInOut(duration: 1.3)
    
    /* Work Timer */
    static let timerWorkCounterDefault = 30
    static let timerWorkCountersShortcuts = [10, 15, 45, 60]
    static let timerWorkExtraCountersShortcuts = [5, 10, 15, 30]

    /* Break Timer */
    static let timerBreakCounterDefault = 5
    static let timerBreakCountersShortcuts = [10, 15, 20, 30]
    static let timerBreakExtraCountersShortcuts = [5, 10, 15, 30]
}
