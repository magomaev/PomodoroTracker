import SwiftUI
import Combine  // Add this import

enum TimerWorkState {
    case ready
    case pause
    case active
    case off
    
    var buttonState: ButtonState {
        switch self {
        case .ready: return .start
        case .pause: return .resume
        case .active: return .stop
        case .off: return .start
        }
    }
    
    var shortcutMode: ShortcutMode {
        switch self {
        case .ready, .off:
            return .counter
        case .pause, .active:
            return .extraCounter
        }
    }
}

class TimerWork: ObservableObject {
    private let defaultTime: Double = 1500 // 25 minutes in seconds
    private let timerManager = TimerManager.shared
    private var cancellables = Set<AnyCancellable>()  // Move this up before init
    
    @Published private(set) var remainingTime: Int
    @Published private(set) var timerState: TimerWorkState = .ready  // Change from .off to .ready
    @Published private(set) var currentSelectedTime: Double
    let theme: AppTheme
    
    let countersTemplates = AppVariables.timerWorkCountersShortcuts
    let extraCountersTemplates = AppVariables.timerWorkExtraCountersShortcuts
    
    init(theme: AppTheme) {
        self.theme = theme
        self.remainingTime = Int(defaultTime)
        self.currentSelectedTime = defaultTime
        
        // Observe TimerManager changes
        timerManager.$activeTimer
            .sink { [weak self] activeTimer in
                if activeTimer == .break_ {
                    self?.timerState = .off
                }
            }
            .store(in: &cancellables)
    }
    
    func handleCounterTap() {
        switch timerState {
        case .active:
            timerState = .pause
        case .pause, .ready:
            timerState = .active
        case .off:
            timerState = .ready
        }
    }
    
    func handleButtonTap() {
        switch timerState {
        case .ready:
            timerState = .active
        case .pause:
            timerState = .active
        case .active:
            timerState = .ready
            remainingTime = Int(defaultTime)
            currentSelectedTime = defaultTime
        case .off:
            timerState = .ready
        }
    }
    
    func handleShortcutTap(_ value: Int) {
        let newTime = value * 60
        switch timerState {
        case .ready, .off:
            remainingTime = newTime
            currentSelectedTime = Double(newTime)
            if timerState == .off {
                toggleOffState()  // This will change state to ready and update TimerManager
            }
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
            timerState = .ready
            remainingTime = Int(currentSelectedTime)
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = Int(ceil(Double(seconds) / 60.0))
        return String(format: "%d", minutes)
    }
    
    func toggleOffState() {
        if timerState == .off {
            timerState = .ready
            timerManager.activeTimer = .work
        } else {
            timerState = .off
            timerManager.activeTimer = .none
        }
    }
}

struct TimerWorkView: View {
    @ObservedObject var timerWork: TimerWork
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            if timerWork.timerState == .off {
                offStateView
            } else {
                activeStateView
            }
            
            ShortcutButtonsView(
                shortcuts: timerWork.timerState == .ready || timerWork.timerState == .off ? timerWork.countersTemplates : timerWork.extraCountersTemplates,
                theme: timerWork.theme,
                mode: timerWork.timerState.shortcutMode,
                action: timerWork.handleShortcutTap
            )
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(timerWork.theme.primary)
        .edgesIgnoringSafeArea(.all)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            timerWork.updateTimer()
        }
    }
    
    private var offStateView: some View {
        HStack {
            HStack {
                Text("TIMER")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(timerWork.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 60)
                
                Text(timerWork.timeString(from: timerWork.remainingTime))
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(timerWork.theme.textPrimary)
                    .frame(height: 200)
                
                CounterStateControl(theme: timerWork.theme, state: timerWork.timerState.buttonState) {
                    timerWork.toggleOffState()
                    timerWork.handleButtonTap()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                timerWork.toggleOffState()
                timerWork.handleButtonTap()
            }
        }
        .frame(height: 60)
        .padding()
        .background(timerWork.theme.onPrimary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
    
    private var activeStateView: some View {
        VStack {
            Text("TIMER")
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(timerWork.theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 60)
            
            GeometryReader { geometry in
                VStack {
                    let availableSize = min(geometry.size.width, geometry.size.height)
                    let chartSize = availableSize - 24
                    
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
    }
}
