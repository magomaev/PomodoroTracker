import SwiftUI

enum TimerWorkState {
    case inactive
    case pause
    case active
    
    var buttonState: ButtonState {
        switch self {
        case .inactive: return .start
        case .pause: return .resume
        case .active: return .stop
        }
    }
    
    var shortcutMode: ShortcutMode {
        switch self {
        case .inactive:
            return .counter
        case .pause, .active:
            return .extraCounter
        }
    }
}

class TimerWork: ObservableObject {
    private let defaultTime: Double = 1500 // 25 minutes in seconds
    
    @Published private(set) var remainingTime: Int
    @Published private(set) var timerState: TimerWorkState = .inactive
    @Published private(set) var currentSelectedTime: Double
    let theme: AppTheme
    
    let shortcuts = [5, 10, 15, 25] // in minutes
    
    init(theme: AppTheme) {
        self.theme = theme
        self.remainingTime = Int(defaultTime)
        self.currentSelectedTime = defaultTime
    }
    
    func handleCounterTap() {
        switch timerState {
        case .active:
            timerState = .pause
        case .pause, .inactive:
            timerState = .active
        }
    }
    
    func handleButtonTap() {
        switch timerState {
        case .inactive:
            timerState = .active
        case .pause:
            timerState = .active
        case .active:
            timerState = .inactive
            remainingTime = Int(defaultTime)
            currentSelectedTime = defaultTime
        }
    }
    
    func handleShortcutTap(_ value: Int) {
        let newTime = value * 60
        switch timerState {
        case .inactive:
            remainingTime = newTime
            currentSelectedTime = Double(newTime)
            timerState = .active
        case .pause, .active:
            remainingTime += newTime
            currentSelectedTime += Double(newTime)
        }
    }
    
    func updateTimer() {
        guard timerState == .active else { return }
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            timerState = .inactive
            remainingTime = Int(currentSelectedTime)
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = Int(ceil(Double(seconds) / 60.0))
        return String(format: "%d", minutes)
    }
}

struct TimerWorkView: View {
    @ObservedObject var timerWork: TimerWork
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            VStack {
                Text("TIMER")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(timerWork.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 60)
                
                GeometryReader { geometry in
                    VStack {
                        // Calculate the new size with margin
                        let availableSize = min(geometry.size.width, geometry.size.height)
                        let chartSize = availableSize - 24 // 12px margin on each side
                        
                        ZStack {
                            Chart(
                                totalTime: timerWork.currentSelectedTime,
                                remainingTime: Double(timerWork.remainingTime),
                                size: CGSize(width: chartSize, height: chartSize),
                                backgroundColor: timerWork.theme.onPrimary,
                                foregroundColor: timerWork.theme.chartTimerBarPrimary
                            )
                            
                            Text(timerWork.timeString(from: timerWork.remainingTime))
                                .font(AppStyles.Typography.timerStyle)
                                .foregroundColor(timerWork.theme.textPrimary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    timerWork.handleCounterTap()
                                }
                        }
                        .frame(width: chartSize, height: chartSize)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                CounterStateControl(theme: timerWork.theme, state: timerWork.timerState.buttonState) {
                    timerWork.handleButtonTap()
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(timerWork.theme.onPrimary)
            .cornerRadius(AppStyles.Layout.defaultCornerRadius)
            
            ShortcutButtonsView(
                shortcuts: timerWork.shortcuts,
                theme: timerWork.theme,
                mode: timerWork.timerState.shortcutMode,
                action: timerWork.handleShortcutTap
            )
        }
        .frame(maxHeight: .infinity)
        .padding(AppStyles.Layout.gapBetweenItems)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            timerWork.updateTimer()
        }
    }
}
