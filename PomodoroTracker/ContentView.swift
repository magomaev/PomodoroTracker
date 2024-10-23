import SwiftUI

struct ContentView: View {
    @State private var currentTheme: AppTheme = AppStyles.creamyTheme
    @StateObject private var timerWork = TimerWork(theme: AppStyles.creamyTheme)
    @StateObject private var timerBreak = TimerBreak(theme: AppStyles.creamyTheme)
    
    var body: some View {
        ZStack {
            currentTheme.primary.ignoresSafeArea()
            
            VStack(spacing: 60) {
                TimerWorkView(timerWork: timerWork)
                TimerBreakView(timerBreak: timerBreak)
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
