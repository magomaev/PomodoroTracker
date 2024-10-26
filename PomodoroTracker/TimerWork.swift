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
    private let defaultTime: Double = 60 // 25 minutes in seconds
    private let timerManager = TimerManager.shared
    private var cancellables = Set<AnyCancellable>()  // Move this up before init
    
    @Published private(set) var remainingTime: Int
    @Published private(set) var timerState: TimerWorkState = .ready  // Change from .off to .ready
    @Published private(set) var currentSelectedTime: Double
    let theme: AppTheme
    
    @Published private(set) var countersTemplates: [Shortcut]
    @Published private(set) var extraCountersTemplates: [Shortcut]
    
    init(theme: AppTheme) {
        self.theme = theme
        self.remainingTime = Int(defaultTime)
        self.currentSelectedTime = defaultTime
        self.countersTemplates = AppVariables.timerWorkCountersShortcuts.map { Shortcut(value: $0) }
        self.extraCountersTemplates = AppVariables.timerWorkExtraCountersShortcuts.map { Shortcut(value: $0) }
        
        // Observe TimerManager changes
        timerManager.$activeTimer
            .sink { [weak self] activeTimer in
                if activeTimer == .break_ {
                    self?.timerState = .off
                } else if activeTimer == .work && self?.timerState == .off {
                    self?.timerState = .ready
                }
            }
            .store(in: &cancellables)
    }
    
    func handleCounterTap() {
        withAnimation(AppVariables.defaultAnimation) {
            switch timerState {
            case .active:
                timerState = .pause
            case .pause, .ready:
                timerState = .active
            case .off:
                timerState = .ready
            }
        }
    }
    
    func handleButtonTap() {
        withAnimation(AppVariables.defaultAnimation) {
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
    }
    
    func handleShortcutTap(_ value: Int) {
        let newTime = value * 60
        withAnimation(AppVariables.defaultAnimation) {
            switch timerState {
            case .ready, .off:
                remainingTime = newTime
                currentSelectedTime = Double(newTime)
                if timerState == .off {
                    toggleOffState()
                }
                timerState = .active
            case .pause, .active:
                remainingTime += newTime
                currentSelectedTime += Double(newTime)
            }
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
        withAnimation(AppVariables.defaultAnimation) {
            if timerState == .off {
                timerState = .ready
                timerManager.activeTimer = .work
            } else {
                timerState = .off
                timerManager.activeTimer = .none
            }
        }
    }
}

struct TimerWorkView: View {
    @ObservedObject var timerWork: TimerWork
    
    var body: some View {
        // Main container that will grow with timer
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            // Timer widget container
            timerContainer
                .animation(AppVariables.defaultAnimation, value: timerWork.timerState)
            
            // Shortcuts stay fixed in size and position
            ShortcutButtonsView(
                shortcuts: timerWork.timerState == .ready || timerWork.timerState == .off ? 
                    timerWork.countersTemplates : timerWork.extraCountersTemplates,
                theme: timerWork.theme,
                mode: timerWork.timerState.shortcutMode,
                action: timerWork.handleShortcutTap
            )
        }
        .frame(maxWidth: .infinity)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            timerWork.updateTimer()
        }
    }
    
    private var timerContainer: some View {
        VStack {
            if timerWork.timerState == .off {
                offStateView
            } else {
                activeStateView
                    .frame(maxHeight: .infinity)
            }
        }
        .background(timerWork.theme.onPrimary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
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
        // .background(Color.red.opacity(0.2)) // Debug BG // Debug background
        .frame(maxHeight: .infinity)
        .padding()
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
}
