import SwiftUI

public struct BarCounterPreview: View {
    let layout: ScreenLayout

    public init(layout: ScreenLayout) {
        self.layout = layout
    }

    public var body: some View {
        GeometryReader { proxy in
            let h = proxy.size.height
            let jiggerH = h * 0.58
            let glassH = h * 0.86

            ZStack {
                RoundedRectangle(cornerRadius: max(16, 24 * layout.scale))
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.25, green: 0.23, blue: 0.18).opacity(0.78),
                                Color(red: 0.06, green: 0.055, blue: 0.045)
                            ],
                            center: .center,
                            startRadius: 16,
                            endRadius: h * 0.78
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: max(16, 24 * layout.scale))
                            .stroke(.white.opacity(0.13), lineWidth: 1)
                    }

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.18),
                                .white.opacity(0.02),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 1)
                    .offset(y: h * 0.30)

                Ellipse()
                    .fill(.black.opacity(0.42))
                    .frame(width: h * 0.80, height: h * 0.10)
                    .blur(radius: 10)
                    .offset(x: -h * 0.15, y: h * 0.28)

                Ellipse()
                    .fill(.black.opacity(0.36))
                    .frame(width: h * 0.62, height: h * 0.09)
                    .blur(radius: 10)
                    .offset(x: h * 0.22, y: h * 0.28)

                HStack(alignment: .bottom, spacing: max(22, 34 * layout.scale)) {
                    Image("jigger_empty")
                        .resizable()
                        .scaledToFit()
                        .frame(height: jiggerH)
                        .shadow(color: .black.opacity(0.45), radius: 10, x: 0, y: 8)

                    Image("highball_mojito_full")
                        .resizable()
                        .scaledToFit()
                        .frame(height: glassH)
                        .shadow(color: .black.opacity(0.48), radius: 14, x: 0, y: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, h * 0.09)
            }
            .clipped()
        }
    }
}
