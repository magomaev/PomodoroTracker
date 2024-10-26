import SwiftUI

struct ContentView: View {
    @State private var currentTheme: AppTheme = AppStyles.creamyTheme
    @StateObject private var timerWork = TimerWork(theme: AppStyles.creamyTheme)
    @StateObject private var timerBreak = TimerBreak(theme: AppStyles.creamyTheme)
    @StateObject private var timerManager = TimerManager.shared
    
    var body: some View {
        ZStack {
            currentTheme.primary.ignoresSafeArea()
            
            VStack(spacing: 60) {
                TimerWorkView(timerWork: timerWork)
                    .animation(.easeInOut(duration: 0.3), value: timerWork.timerState)
                
                TimerBreakView(timerBreak: timerBreak)
                    .animation(.easeInOut(duration: 0.3), value: timerBreak.timerState)
            }
            .padding()
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { gesture in
                        let verticalAmount = gesture.translation.height
                        let verticalThreshold: CGFloat = 50
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if verticalAmount < -verticalThreshold {
                                // Swipe up
                                if timerBreak.timerState == .off {
                                    timerManager.handleSwipeUp()
                                }
                            } else if verticalAmount > verticalThreshold {
                                // Swipe down
                                if timerWork.timerState == .off {
                                    timerManager.handleSwipeDown()
                                }
                            }
                        }
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
