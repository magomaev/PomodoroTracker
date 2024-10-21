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
    @Published private(set) var remainingTime = 1500 // 25 minutes in seconds
    @Published private(set) var timerState: TimerWidgetState = .inactive
    let theme: AppTheme
    
    let totalTime: Double = 1500
    let shortcuts = [5, 10, 15, 25] // in minutes
    
    init(theme: AppTheme) {
        self.theme = theme
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
            remainingTime = Int(totalTime)
        }
    }
    
    func handleShortcutTap(_ value: Int) {
        switch timerState {
        case .inactive:
            remainingTime = value * 60
            timerState = .active
        case .pause, .active:
            remainingTime += value * 60
        }
    }
    
    func updateTimer() {
        guard timerState == .active else { return }
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            timerState = .inactive
            remainingTime = Int(totalTime)
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

struct TimerWidgetView: View {
    @ObservedObject var timerWidget: TimerWidget
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            VStack() {
                Text("TIMER")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(timerWidget.theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                
                GeometryReader { geometry in
                    ZStack {
                        Chart(
                            progress: (timerWidget.totalTime - Double(timerWidget.remainingTime)) / timerWidget.totalTime,
                            size: geometry.size,
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
                }
                .aspectRatio(1, contentMode: .fit)
                
                CounterStateControl(theme: timerWidget.theme, state: timerWidget.timerState.buttonState) {
                    timerWidget.handleButtonTap()
                }
            }
            .padding()
            .background(timerWidget.theme.onPrimary)
            .cornerRadius(AppStyles.Layout.defaultCornerRadius)
            
            ShortcutButtonsView(
                shortcuts: timerWidget.shortcuts,
                theme: timerWidget.theme,
                mode: timerWidget.timerState.shortcutMode,
                action: timerWidget.handleShortcutTap
            )
        }
        .padding(AppStyles.Layout.gapBetweenItems)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            timerWidget.updateTimer()
        }
    }
}
