import SwiftUI

enum ButtonState {
    case resume
    case stop
    case pause
    
    var text: String {
        switch self {
        case .resume:
            return "RESUME"
        case .stop:
            return "STOP"
        case .pause:
            return "PAUSE"
        }
    }
}

struct CounterStateControl: View {
    let theme: AppTheme
    let state: ButtonState
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(state.text)
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(theme.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
    }
}
