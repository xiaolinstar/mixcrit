import SwiftUI

public struct BubbleLayer: View {
    public let width: CGFloat
    public let height: CGFloat
    public let intensity: Double
    public let motionTick: Int

    public init(width: CGFloat, height: CGFloat, intensity: Double, motionTick: Int) {
        self.width = width
        self.height = height
        self.intensity = intensity
        self.motionTick = motionTick
    }

    public var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                let progress = CGFloat((index * 17 + motionTick * 11) % 100) / 100
                let bubbleSize = CGFloat(4 + (index % 4) * 2)
                let xOffset = (CGFloat(index % 5) / 4 - 0.5) * width * 0.72
                let yOffset = -height * progress

                Circle()
                    .stroke(.white.opacity(0.28 + 0.34 * intensity), lineWidth: 1.2)
                    .background(Circle().fill(.white.opacity(0.05)))
                    .frame(width: bubbleSize, height: bubbleSize)
                    .offset(x: xOffset, y: yOffset)
                    .opacity(0.35 + 0.5 * intensity)
            }
        }
        .frame(width: width, height: height, alignment: .bottom)
        .animation(.easeInOut(duration: 0.45), value: motionTick)
        .allowsHitTesting(false)
    }
}
