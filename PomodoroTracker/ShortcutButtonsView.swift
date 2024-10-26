struct ShortcutButtonsView: View {
    let shortcuts: [Shortcut]
    let extraShortcuts: [Shortcut]
    let theme: AppTheme
    let mode: ShortcutMode
    let action: (Int) -> Void
    
    var body: some View {
        HStack(spacing: AppStyles.Layout.gapBetweenItems) {
            ForEach(0..<max(shortcuts.count, extraShortcuts.count), id: \.self) { index in
                if index < (mode == .counter ? shortcuts.count : extraShortcuts.count) {
                    let shortcut = mode == .counter ? shortcuts[index] : extraShortcuts[index]
                    Button(action: {
                        action(shortcut.value)
                    }) {
                        Text("\(shortcut.value)")
                            .font(AppStyles.Typography.defaultStyle)
                            .foregroundColor(theme.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(theme.onPrimary)
                            .cornerRadius(AppStyles.Layout.defaultCornerRadius)
                    }
                    .id(index) // Maintain view identity by index position
                    .transition(.identity) // Smooth transition between states
                }
            }
        }
        .animation(AppVariables.defaultAnimation, value: mode)
    }
}
