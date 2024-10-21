import SwiftUI

struct ContentView: View {
    @State private var currentTheme: AppTheme = AppStyles.creamyTheme
    @StateObject private var timerWidget = TimerWidget(theme: AppStyles.creamyTheme)
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenContainers) {
            TimerWidgetView(timerWidget: timerWidget)
            BreakFrame(theme: currentTheme)
        }
        .padding()
        .background(currentTheme.primary)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
