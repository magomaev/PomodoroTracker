import SwiftUI
/* 123 */
enum TimerBreakState {
    case inactive
    case pause
    case active
    case off
    
    var buttonState: ButtonState {
        switch self {
        case .inactive: return .start
        case .pause: return .resume
        case .active: return .stop
        case .off: return .start
        }
    }
    
    var shortcutMode: ShortcutMode {
        switch self {
        case .inactive, .off:
            return .counter
        case .pause, .active:
            return .extraCounter
        }
    }
}

class TimerBreak: ObservableObject {
    private let defaultTime: Double = 300 // 5 minutes in seconds
    
    @Published private(set) var remainingTime: Int
    @Published private(set) var timerState: TimerBreakState = .off
    @Published private(set) var currentSelectedTime: Double
    let theme: AppTheme
    
    let shortcuts = [1, 3, 5, 10] // in minutes
    
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
        case .off:
            // Do nothing when off, or optionally change to inactive
            timerState = .inactive
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
        case .off:
            timerState = .inactive
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
        case .off:
            // When off, set the time and switch to inactive
            remainingTime = newTime
            currentSelectedTime = Double(newTime)
            timerState = .inactive
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
    
    func toggleOffState() {
        timerState = timerState == .off ? .inactive : .off
    }
}

struct TimerBreakView: View {
    @ObservedObject var timerBreak: TimerBreak
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            if timerBreak.timerState == .off {
                offStateView
            } else {
                activeStateView
            }
            
            ShortcutButtonsView(
                shortcuts: timerBreak.shortcuts,
                theme: timerBreak.theme,
                mode: timerBreak.timerState.shortcutMode,
                action: timerBreak.handleShortcutTap
            )
            
            // Temporary button to toggle off state
            Button(action: {
                timerBreak.toggleOffState()
            }) {
                Text(timerBreak.timerState == .off ? "Turn On" : "Turn Off")
                    .padding()
                    .background(timerBreak.theme.primary)
                    .foregroundColor(timerBreak.theme.textPrimary)
                    .cornerRadius(AppStyles.Layout.defaultCornerRadius)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(timerBreak.theme.primary)
        .edgesIgnoringSafeArea(.all)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            timerBreak.updateTimer()
        }
    }
    
    private var offStateView: some View {
        HStack {
            Text("BREAK")
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(timerBreak.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 60)
            
            Text(timerBreak.timeString(from: timerBreak.remainingTime))
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(timerBreak.theme.textPrimary)
                .frame(height: 200)
            
            CounterStateControl(theme: timerBreak.theme, state: timerBreak.timerState.buttonState) {
                timerBreak.handleButtonTap()
            }
        }
        .frame(height: 60)
        .padding()
        .background(timerBreak.theme.onPrimary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
    
    private var activeStateView: some View {
        VStack {
            Text("BREAK")
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(timerBreak.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 60)
            
            GeometryReader { geometry in
                VStack {
                    let availableSize = min(geometry.size.width, geometry.size.height)
                    let chartSize = availableSize - 24 // 12px margin on each side
                    
                    ZStack {
                        Chart(
                            totalTime: timerBreak.currentSelectedTime,
                            remainingTime: Double(timerBreak.remainingTime),
                            size: CGSize(width: chartSize, height: chartSize),
                            backgroundColor: timerBreak.theme.onPrimary,
                            foregroundColor: timerBreak.theme.chartBreakBarPrimary
                        )
                        
                        Text(timerBreak.timeString(from: timerBreak.remainingTime))
                            .font(AppStyles.Typography.timerStyle)
                            .foregroundColor(timerBreak.theme.textPrimary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                timerBreak.handleCounterTap()
                            }
                    }
                    .frame(width: chartSize, height: chartSize)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            CounterStateControl(theme: timerBreak.theme, state: timerBreak.timerState.buttonState) {
                timerBreak.handleButtonTap()
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(timerBreak.theme.onPrimary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
}

struct TimerBreakView_Previews: PreviewProvider {
    static var previews: some View {
        TimerBreakView(timerBreak: TimerBreak(theme: AppStyles.creamyTheme))
    }
}
