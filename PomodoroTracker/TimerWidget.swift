import SwiftUI

enum TimerWidgetState {
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

class TimerWidget: ObservableObject {
    private let defaultTime: Double = 1500 // 25 minutes in seconds
    
    @Published private(set) var remainingTime: Int
    @Published private(set) var timerState: TimerWidgetState = .inactive
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

struct TimerWidgetView: View {
    @ObservedObject var timerWidget: TimerWidget
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            VStack {
                Text("TIMER")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(timerWidget.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 80)
                    .background(Color.red.opacity(0.3)) // Added red background for visual debugging
                
                GeometryReader { geometry in
                    VStack {
                        ZStack {
                            Chart(
                                totalTime: timerWidget.currentSelectedTime,
                                remainingTime: Double(timerWidget.remainingTime),
                                size: CGSize(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height)),
                                backgroundColor: timerWidget.theme.onPrimary,
                                foregroundColor: timerWidget.theme.chartTimerBarPrimary
                            )
                            
                            Text(timerWidget.timeString(from: timerWidget.remainingTime))
                                .font(AppStyles.Typography.timerStyle)
                                .foregroundColor(timerWidget.theme.textPrimary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    timerWidget.handleCounterTap()
                                }
                        }
                        .frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height))
                        .background(Color.red.opacity(0.3)) // Added red background for visual debugging
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red.opacity(0.3)) // Added red background for visual debugging
                }
                
                CounterStateControl(theme: timerWidget.theme, state: timerWidget.timerState.buttonState) {
                    timerWidget.handleButtonTap()
                }
                .background(Color.red.opacity(0.3)) // Added red background for visual debugging
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(timerWidget.theme.onPrimary)
            .cornerRadius(AppStyles.Layout.defaultCornerRadius)
            .background(Color.red.opacity(0.3)) // Added red background for visual debugging
            
            ShortcutButtonsView(
                shortcuts: timerWidget.shortcuts,
                theme: timerWidget.theme,
                mode: timerWidget.timerState.shortcutMode,
                action: timerWidget.handleShortcutTap
            )
        }
        .frame(maxHeight: .infinity)
        .padding(AppStyles.Layout.gapBetweenItems)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            timerWidget.updateTimer()
        }
    }
}
