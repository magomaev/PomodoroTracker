import SwiftUI

class TimerBreak: ObservableObject {
    @Published var theme: AppTheme
    @Published var timeString: String = "05:00"
    @Published var isRunning: Bool = false
    
    init(theme: AppTheme) {
        self.theme = theme
    }
    
    func startPause() {
        isRunning.toggle()
        // Implement timer logic here
    }
    
    func reset() {
        isRunning = false
        timeString = "05:00"
        // Implement reset logic here
    }
}

struct TimerBreakView: View {
    @ObservedObject var timerBreak: TimerBreak
    
    var body: some View {
        VStack {
            VStack {
                Text("BREAK")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(timerBreak.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 60)
                
                Text(timerBreak.timeString)
                    .font(AppStyles.Typography.timerStyle)
                    .foregroundColor(timerBreak.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Button(action: timerBreak.startPause) {
                        Image(systemName: timerBreak.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(timerBreak.theme.primary)
                    }
                    
                    Button(action: timerBreak.reset) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(timerBreak.theme.primary)
                    }
                }
                .padding(.top, 20)
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(timerBreak.theme.onPrimary)
            .cornerRadius(AppStyles.Layout.defaultCornerRadius)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(timerBreak.theme.background)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TimerBreakView_Previews: PreviewProvider {
    static var previews: some View {
        TimerBreakView(timerBreak: TimerBreak())
    }
}
