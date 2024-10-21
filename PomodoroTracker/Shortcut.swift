import SwiftUI

enum ShortcutMode {
    case counter
    case extraCounter
}

struct ShortcutButtonsView: View {
    let shortcuts: [Int]
    let theme: AppTheme
    let action: (Int) -> Void
    let mode: ShortcutMode
    
    init(shortcuts: [Int], theme: AppTheme, mode: ShortcutMode, action: @escaping (Int) -> Void) {
        self.shortcuts = shortcuts
        self.theme = theme
        self.mode = mode
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: AppStyles.Layout.gapBetweenItems) {
            ForEach(shortcuts, id: \.self) { value in
                Button(action: {
                    action(value)
                }) {
                    Text(buttonText(for: value))
                        .font(AppStyles.Typography.defaultStyle)
                        .foregroundColor(theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(theme.onPrimary)
                        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
                }
            }
        }
        .frame(height: 80)
    }
    
    private func buttonText(for value: Int) -> String {
        switch mode {
        case .counter:
            return "\(value)"
        case .extraCounter:
            return "+\(value)"
        }
    }
}
