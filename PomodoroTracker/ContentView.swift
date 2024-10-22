import SwiftUI

struct ContentView: View {
    @State private var currentTheme: AppTheme = AppStyles.creamyTheme
    @StateObject private var timerWidget = TimerWidget(theme: AppStyles.creamyTheme)
    
    var body: some View {
        ZStack {
            currentTheme.primary.ignoresSafeArea()
            
            VStack(spacing: AppStyles.Layout.gapBetweenContainers) {
                TimerWidgetView(timerWidget: timerWidget)
            /*     BreakFrame(theme: currentTheme) */
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
