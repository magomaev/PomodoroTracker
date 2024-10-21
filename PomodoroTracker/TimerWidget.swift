import SwiftUI

struct TimerWidget: View {
    @State private var remainingTime = 30
    @State private var buttonState: ButtonState = .stop
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            Text("TIMER")
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(theme.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .stroke(theme.onPrimary, lineWidth: 5)
                    .frame(width: AppStyles.Layout.chartSizeActive.width, height: AppStyles.Layout.chartSizeActive.height)
                
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(theme.chartTimerBarPrimary, lineWidth: 5)
                    .frame(width: AppStyles.Layout.chartSizeActive.width, height: AppStyles.Layout.chartSizeActive.height)
                    .rotationEffect(.degrees(-90))
                
                Text("\(remainingTime)")
                    .font(AppStyles.Typography.timerStyle)
                    .foregroundColor(theme.textPrimary)
            }
            
            CounterStateControl(theme: theme, state: buttonState) {
                // Action will be implemented later
                switch buttonState {
                case .stop:
                    buttonState = .pause
                case .pause:
                    buttonState = .resume
                case .resume:
                    buttonState = .stop
                }
            }
        }
        .padding(20)
        .background(theme.onPrimary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
}
