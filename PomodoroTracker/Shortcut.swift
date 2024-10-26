import SwiftUI

enum ShortcutMode {
    case counter
    case extraCounter
}

struct Shortcut: Identifiable {
    let id: UUID
    let value: Int
    
    init(value: Int) {
        self.id = UUID()
        self.value = value
    }
}

struct ShortcutButtonsView: View {
    let shortcuts: [Shortcut]
    let theme: AppTheme
    let action: (Int) -> Void
    let mode: ShortcutMode
    
    init(shortcuts: [Shortcut], theme: AppTheme, mode: ShortcutMode, action: @escaping (Int) -> Void) {
        self.shortcuts = shortcuts
        self.theme = theme
        self.mode = mode
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: AppStyles.Layout.gapBetweenItems) {
            ForEach(shortcuts) { shortcut in
                Button(action: {
                    action(shortcut.value)
                }) {
                    Text(buttonText(for: shortcut.value))
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

