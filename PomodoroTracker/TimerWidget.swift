import SwiftUI

struct TimerWidget: View {
    @State private var remainingTime = 30
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
            
            Button(action: {
                // Action will be implemented later
            }) {
                Text("STOP")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
        }
        .padding(20)
        .background(theme.onPrimary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
}
