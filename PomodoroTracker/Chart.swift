import SwiftUI

struct Chart: View {
    let totalTime: Double
    let remainingTime: Double
    let size: CGSize
    let backgroundColor: Color
    let foregroundColor: Color
    
    private var progress: Double {
        remainingTime / totalTime
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: 15)
                .frame(width: size.width, height: size.height)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(foregroundColor, lineWidth: 15)
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(-90))
        }
    }
}
