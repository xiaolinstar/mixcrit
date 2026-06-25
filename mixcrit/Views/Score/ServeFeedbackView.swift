import SwiftUI

public struct ServeFeedbackView: View {
    public let mix: MojitoMix
    public let feedback: ServeFeedback
    public let onRetry: () -> Void
    public let onBackToBar: () -> Void

    public init(
        mix: MojitoMix,
        feedback: ServeFeedback,
        onRetry: @escaping () -> Void,
        onBackToBar: @escaping () -> Void
    ) {
        self.mix = mix
        self.feedback = feedback
        self.onRetry = onRetry
        self.onBackToBar = onBackToBar
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = ScreenLayout(size: proxy.size, safeArea: proxy.safeAreaInsets)
            let glassH = layout.contentHeight * 0.26

            VStack(spacing: layout.sectionSpacing * 1.6) {
                Spacer(minLength: 0)

                CocktailGlassView(
                    mix: mix,
                    isShaking: false,
                    motionTick: 0,
                    fallingIceTick: 0,
                    isFallingIceVisible: false
                )
                .frame(width: glassH * 0.72, height: glassH)

                VStack(spacing: max(6, 9 * layout.scale)) {
                    Text(feedback.grade)
                        .font(.system(size: layout.gradeFontSize, weight: .black, design: .rounded))
                        .foregroundStyle(gradeColor)
                    Text(feedback.customerLine)
                        .font((layout.isCompact ? Font.subheadline : Font.headline).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.82))
                        .lineLimit(3)
                        .minimumScaleFactor(0.78)
                }
                .padding(.horizontal, layout.horizontalPadding + 8)

                HStack(spacing: max(7, 9 * layout.scale)) {
                    metric(
                        title: "金币",
                        value: "+\(feedback.coins)",
                        color: Color(red: 0.96, green: 0.76, blue: 0.34)
                    )
                    metric(
                        title: "经验",
                        value: "+\(feedback.experience)",
                        color: Color(red: 0.46, green: 0.78, blue: 1.0)
                    )
                    metric(
                        title: "好感",
                        value: "\(feedback.satisfaction)",
                        color: Color(red: 0.28, green: 0.82, blue: 0.48)
                    )
                }
                .padding(.horizontal, layout.horizontalPadding)

                VStack(alignment: .leading, spacing: max(6, 9 * layout.scale)) {
                    ForEach(feedback.tags, id: \.self) { tag in
                        Label(tag, systemImage: "quote.bubble.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.84))
                            .lineLimit(2)
                            .minimumScaleFactor(0.82)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(max(10, 15 * layout.scale))
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, layout.horizontalPadding)

                HStack(spacing: max(8, 12 * layout.scale)) {
                    Button(action: onRetry) {
                        Label("再来一杯", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, max(10, 14 * layout.scale))
                    }
                    .buttonStyle(.bordered)

                    Button(action: onBackToBar) {
                        Label("回到酒吧", systemImage: "house.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, max(10, 14 * layout.scale))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.18, green: 0.70, blue: 0.42))
                }
                .font((layout.isCompact ? Font.caption : Font.subheadline).weight(.bold))
                .padding(.horizontal, layout.horizontalPadding)

                Spacer(minLength: 0)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .padding(.vertical, layout.verticalPadding)
    }
}
    private func metric(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.62))
            Text(value)
                .font(.headline.weight(.black))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    private var gradeColor: Color {
        switch feedback.grade {
        case "S": Color(red: 0.98, green: 0.80, blue: 0.24)
        case "A": Color(red: 0.22, green: 0.82, blue: 0.48)
        case "B": Color(red: 0.48, green: 0.78, blue: 1.0)
        case "C": Color(red: 0.95, green: 0.60, blue: 0.24)
        default: Color(red: 0.95, green: 0.35, blue: 0.35)
        }
    }
}
