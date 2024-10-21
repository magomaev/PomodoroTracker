import SwiftUI

struct BreakFrame: View {
    let theme: AppTheme
    
    var body: some View {
        HStack(spacing: AppStyles.Layout.gapBetweenItems) {
            Text("BREAK")
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(theme.textSecondary)
            
            Spacer()
            
            Text("10")
                .font(AppStyles.Typography.defaultStyle)
                .foregroundColor(theme.textPrimary)
            
            Button(action: {
                // Action will be implemented later
            }) {
                Text("START")
                    .font(AppStyles.Typography.defaultStyle)
                    .foregroundColor(theme.textPrimary)
                    .frame(width: 80, height: 40)
                    .background(theme.onPrimary)
                    .cornerRadius(AppStyles.Layout.defaultCornerRadius)
            }
        }
        .padding()
        .background(theme.primary)
        .cornerRadius(AppStyles.Layout.defaultCornerRadius)
    }
}
