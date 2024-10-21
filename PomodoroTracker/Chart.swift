import SwiftUI

struct Chart: View {
    let progress: Double
    let size: CGSize
    let backgroundColor: Color
    let foregroundColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: 5)
                .frame(width: size.width, height: size.height)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(foregroundColor, lineWidth: 5)
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(-90))
        }
    }
}
