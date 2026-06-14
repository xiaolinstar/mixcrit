import SwiftUI

public struct BarCounterPreview: View {
    let layout: ScreenLayout

    public init(layout: ScreenLayout) {
        self.layout = layout
    }

    public var body: some View {
        GeometryReader { proxy in
            let h = proxy.size.height
            let bottleTall = h * 0.58
            let bottleMid = h * 0.46
            let glassW = h * 0.48
            let glassH = h * 0.74

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: max(16, 24 * layout.scale))
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.20, green: 0.13, blue: 0.08),
                                Color(red: 0.06, green: 0.04, blue: 0.03)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: max(16, 24 * layout.scale))
                            .stroke(.white.opacity(0.10), lineWidth: 1)
                    }

                HStack(alignment: .bottom, spacing: max(12, 22 * layout.scale)) {
                    BottleView(color: Color(red: 0.84, green: 0.94, blue: 0.90), height: bottleTall)
                    BottleView(color: Color(red: 0.38, green: 0.86, blue: 0.42), height: bottleMid)
                    CocktailGlassView(mix: .preview, isShaking: false, motionTick: 0, fallingIceTick: 0, isFallingIceVisible: false)
                        .frame(width: glassW, height: glassH)
                    BottleView(color: Color(red: 0.96, green: 0.78, blue: 0.30), height: bottleMid * 1.1)
                }
                .padding(.bottom, h * 0.10)

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.28, green: 0.16, blue: 0.08))
                    .frame(height: h * 0.16)
                    .shadow(color: .black.opacity(0.35), radius: 10, y: -3)
            }
        }
    }
}
