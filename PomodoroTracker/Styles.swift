import SwiftUI

enum ThemeStyle {
    case creamy
    case green
}

struct ThemeColors {
    let primary: Color
    let accent1: Color
    let accent2: Color
}

struct AppTheme {
    let colors: ThemeColors
    
    var primary: Color { colors.primary }
    var onPrimary: Color { Color.black.opacity(0.06) }

    var textPrimary: Color { Color.black.opacity(0.9) }
    var textSecondary: Color { Color.black.opacity(0.4) }
    
    var chartTimerBarPrimary: Color { colors.accent1 }
    var chartTimerBarSecondary: Color { onPrimary }
    var chartTimerBarSecondaryStroke: Color { Color.black.opacity(0.3) }
    
    var chartBreakBarPrimary: Color { colors.accent2 }
    var chartBreakBarSecondary: Color { onPrimary }
    var chartBreakBarSecondaryStroke: Color { Color.black.opacity(0.3) }
    
    var shadowActive: ShadowStyle { ShadowStyle(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 10) }
    var shadowInactive: ShadowStyle { ShadowStyle(color: Color.black.opacity(0), radius: 0, x: 0, y: 0) }
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

struct AppStyles {
    static let creamyTheme = AppTheme(
        colors: ThemeColors(
            primary: Color(red: 0.953, green: 0.945, blue: 0.890),
            accent1: Color.black,
            accent2: Color(red: 0.039, green: 0.361, blue: 0.286)
        )
    )
    
    static let greenTheme = AppTheme(
        colors: ThemeColors(
            primary: Color(red: 0.922, green: 0.953, blue: 0.890),
            accent1: Color.black,
            accent2: Color(red: 0.039, green: 0.361, blue: 0.286)
        )
    )
    
    static let defaultTheme = creamyTheme
    
    struct Typography {
        static let timerStyle = Font.system(size: 100, weight: .regular, design: .monospaced)
        static let defaultStyle = Font.system(size: 20, weight: .regular, design: .monospaced)
    }
    
    struct Layout {
        static let defaultCornerRadius: CGFloat = 32
        static let chartBarCornerRadius: CGFloat = 0
        static let gapBetweenItems: CGFloat = 4
        static let chartSizeActive: CGSize = CGSize(width: 260, height: 260)
        static let chartSizeInactive: CGSize = CGSize(width: 250, height: 250)
    }
}
