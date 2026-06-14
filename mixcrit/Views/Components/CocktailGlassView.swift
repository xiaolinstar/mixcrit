import SwiftUI

public struct CocktailGlassView: View {
    public let mix: MojitoMix
    public let isShaking: Bool
    public let motionTick: Int
    public let fallingIceTick: Int
    public let isFallingIceVisible: Bool

    public init(mix: MojitoMix, isShaking: Bool, motionTick: Int, fallingIceTick: Int, isFallingIceVisible: Bool) {
        self.mix = mix
        self.isShaking = isShaking
        self.motionTick = motionTick
        self.fallingIceTick = fallingIceTick
        self.isFallingIceVisible = isFallingIceVisible
    }

    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let glassWidth = size.width * 0.58
            let glassHeight = size.height * 0.86
            let liquidHeight = max(8, glassHeight * 0.64 * mix.fillRatio)
            let sloshOffset = motionTick.isMultiple(of: 2) ? -5.0 : 5.0

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: glassWidth * 0.12)
                    .fill(
                        LinearGradient(
                            colors: [
                                mix.liquidColor.opacity(0.80),
                                mix.liquidColor.opacity(0.48)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: glassWidth * 0.88, height: liquidHeight)
                    .overlay(alignment: .top) {
                        Capsule()
                            .fill(.white.opacity(0.30))
                            .frame(height: 8)
                            .offset(x: sloshOffset)
                            .rotationEffect(.degrees(motionTick.isMultiple(of: 2) ? -2 : 2))
                            .padding(.horizontal, 8)
                            .padding(.top, 3)
                    }
                    .padding(.bottom, glassHeight * 0.07)
                    .animation(.spring(response: 0.4, dampingFraction: 0.76), value: mix.totalLiquid)
                    .animation(.spring(response: 0.32, dampingFraction: 0.42), value: motionTick)

                if mix.amount(for: .soda) > 0 {
                    BubbleLayer(
                        width: glassWidth * 0.78,
                        height: max(20, liquidHeight - 8),
                        intensity: min(1, mix.amount(for: .soda) / MojitoIngredient.soda.targetAmount),
                        motionTick: motionTick
                    )
                    .padding(.bottom, glassHeight * 0.10)
                }

                iceLayer(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.10)

                FallingIceView(tick: fallingIceTick, isVisible: isFallingIceVisible)
                    .frame(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.05)

                mintLayer(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.14)

                if mix.amount(for: .limeJuice) > 0 {
                    limeGarnish(width: glassWidth, height: glassHeight)
                }

                Image("highball_glass_empty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: glassWidth * 1.52, height: glassHeight * 1.04)
                    .offset(y: -glassHeight * 0.015)
                    .allowsHitTesting(false)
            }
            .frame(width: size.width, height: size.height)
            .rotationEffect(.degrees(isShaking ? -4 : 0))
            .offset(x: isShaking ? 7 : 0)
            .animation(.linear(duration: 0.08), value: isShaking)
            .animation(.spring(response: 0.30, dampingFraction: 0.55), value: motionTick)
        }
    }

    private func iceLayer(width: CGFloat, height: CGFloat) -> some View {
        let cubeSize = width * 0.22
        return ZStack {
            ForEach(0..<min(mix.iceCount, 10), id: \.self) { index in
                Image("ice_cube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: cubeSize, height: cubeSize)
                    .opacity(0.72)
                    .rotationEffect(.degrees(Double(index * 17)))
                    .offset(
                        x: CGFloat((index % 3) - 1) * width * 0.20,
                        y: -CGFloat(index / 3) * cubeSize * 0.86
                    )
            }
        }
        .frame(width: width, height: height * 0.42, alignment: .bottom)
    }

    private func mintLayer(width: CGFloat, height: CGFloat) -> some View {
        let leafSize = width * 0.22
        return ZStack {
            ForEach(0..<min(mix.mintLeaves, 10), id: \.self) { index in
                Image("mint_leaf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: leafSize, height: leafSize)
                    .opacity(0.90)
                    .rotationEffect(.degrees(Double(index * 31)))
                    .offset(
                        x: CGFloat((index % 4) - 2) * width * 0.14,
                        y: -CGFloat(index / 4) * leafSize * 0.72
                    )
            }
        }
        .frame(width: width, height: height * 0.46, alignment: .bottom)
    }

    private func limeGarnish(width: CGFloat, height: CGFloat) -> some View {
        Image("lime_slice")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.34, height: width * 0.34)
            .rotationEffect(.degrees(-18))
            .offset(x: width * 0.26, y: -height * 0.70)
            .shadow(color: .black.opacity(0.22), radius: 5, y: 3)
            .allowsHitTesting(false)
    }
}
