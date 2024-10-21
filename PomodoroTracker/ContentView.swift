import SwiftUI

struct ContentView: View {
    @State private var currentTheme: AppTheme = AppStyles.creamyTheme
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenContainers) {
            TimerFrame(theme: currentTheme)
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
