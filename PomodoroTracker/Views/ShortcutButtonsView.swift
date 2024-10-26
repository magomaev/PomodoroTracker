import SwiftUI

struct ShortcutButtonsView: View {
    let counters: [Shortcut]
    let extraCounters: [Shortcut]
    let theme: AppTheme
    let mode: ShortcutMode
    let action: (Int) -> Void
    
    var body: some View {
        ZStack {
            // Regular counters
            buttonsRow(shortcuts: counters, isExtra: false)
                .opacity(mode == .counter ? 1 : 0)
            
            // Extra counters
            buttonsRow(shortcuts: extraCounters, isExtra: true)
                .opacity(mode == .extraCounter ? 1 : 0)
        }
        .animation(AppVariables.defaultAnimation, value: mode)
        .frame(height: 80)
    }
    
    private func buttonsRow(shortcuts: [Shortcut], isExtra: Bool) -> some View {
        HStack(spacing: AppStyles.Layout.gapBetweenItems) {
            ForEach(shortcuts) { shortcut in
                Button(action: {
                    action(shortcut.value)
                }) {
                    Text(buttonText(for: shortcut.value, isExtra: isExtra))
                        .font(AppStyles.Typography.defaultStyle)
                        .foregroundColor(theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(theme.onPrimary)
                        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
                }
            }
        }
    }
    
    private func buttonText(for value: Int, isExtra: Bool) -> String {
        isExtra ? "+\(value)" : "\(value)"
    }
}
