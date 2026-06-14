import SwiftUI

public struct FallingIceView: View {
    public let tick: Int
    public let isVisible: Bool

    public init(tick: Int, isVisible: Bool) {
        self.tick = tick
        self.isVisible = isVisible
    }

    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            if tick > 0, isVisible {
                Image("ice_cube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .rotationEffect(.degrees(tick.isMultiple(of: 2) ? 18 : -18))
                    .offset(
                        x: size.width * 0.5 + CGFloat((tick % 3) - 1) * 20 - 13,
                        y: size.height * 0.15
                    )
                    .transition(.asymmetric(
                        insertion: .offset(y: -120).combined(with: .opacity),
                        removal: .scale(scale: 0.6).combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.38, dampingFraction: 0.45), value: tick)
            }
        }
        .allowsHitTesting(false)
    }
}
