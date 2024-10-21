import SwiftUI

struct TimerFrame: View {
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: AppStyles.Layout.gapBetweenItems) {
            TimerWidget(theme: theme)
            ShortcutButtonsView(shortcuts: [5, 10, 15, 30], theme: theme, mode: .extraCounter) { value in
                // Action will be implemented later
            }
        }
        .padding(AppStyles.Layout.gapBetweenItems)
    }
}
