import SwiftUI

enum ButtonState: String {
    case start = "START"
    case stop = "STOP"
    case pause = "PAUSE"
    case resume = "RESUME"
}

struct CounterStateControl: View {
    let theme: AppTheme
    let state: ButtonState
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(state.rawValue)
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 80)
        }
    }
}
