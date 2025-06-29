import SwiftUI

struct AnalogStickView: View {
    @Binding var stickPosition: CGPoint
    
    let stickRadius: CGFloat = 50
    let handleRadius: CGFloat = 25

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: stickRadius * 2, height: stickRadius * 2)

            Circle()
                .fill(Color.white)
                .frame(width: handleRadius * 2, height: handleRadius * 2)
                .offset(x: stickPosition.x, y: stickPosition.y)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let distance = sqrt(pow(value.location.x, 2) + pow(value.location.y, 2))
                    if distance <= stickRadius {
                        self.stickPosition = value.location
                    } else {
                        let angle = atan2(value.location.y, value.location.x)
                        self.stickPosition = CGPoint(x: stickRadius * cos(angle), y: stickRadius * sin(angle))
                    }
                }
                .onEnded { _ in
                    self.stickPosition = .zero
                }
        )
    }
}

struct AnalogStickView_Previews: PreviewProvider {
    static var previews: some View {
        AnalogStickView(stickPosition: .constant(.zero))
            .previewLayout(.fixed(width: 200, height: 200))
    }
} 