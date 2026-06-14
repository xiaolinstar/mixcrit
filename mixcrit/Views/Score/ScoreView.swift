import SwiftUI

public struct ScoreView: View {
    public let mix: MojitoMix
    public let score: MojitoScore
    public let onRetry: () -> Void
    public let onBackToBar: () -> Void

    public init(mix: MojitoMix, score: MojitoScore, onRetry: @escaping () -> Void, onBackToBar: @escaping () -> Void) {
        self.mix = mix
        self.score = score
        self.onRetry = onRetry
        self.onBackToBar = onBackToBar
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = ScreenLayout(size: proxy.size, safeArea: proxy.safeAreaInsets)
            let glassH = layout.contentHeight * 0.28
            let feedbackLimit = layout.isUltraCompact ? 3 : score.feedback.count

            VStack(spacing: layout.sectionSpacing * 1.5) {
                Spacer(minLength: 0)

                CocktailGlassView(mix: mix, isShaking: false, motionTick: 0, fallingIceTick: 0, isFallingIceVisible: false)
                    .frame(width: glassH * 0.72, height: glassH)

                VStack(spacing: max(4, 8 * layout.scale)) {
                    Text(score.grade)
                        .font(.system(size: layout.gradeFontSize, weight: .black, design: .rounded))
                        .foregroundStyle(gradeColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Text("\(score.total) 分")
                        .font((layout.isCompact ? Font.title3 : Font.title).bold())
                    Text(score.total >= 80 ? "客人很满意这杯 Mojito" : "这杯还可以再打磨一下")
                        .font((layout.isCompact ? Font.subheadline : Font.headline).weight(.semibold))
                        .foregroundStyle(.white.opacity(0.74))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                VStack(alignment: .leading, spacing: max(6, 10 * layout.scale)) {
                    ForEach(score.feedback.prefix(feedbackLimit), id: \.self) { item in
                        Label(item, systemImage: "sparkle")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.82))
                            .lineLimit(layout.isUltraCompact ? 1 : 2)
                            .minimumScaleFactor(0.85)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(max(10, 16 * layout.scale))
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, layout.horizontalPadding)

                HStack(spacing: max(8, 12 * layout.scale)) {
                    Button(action: onRetry) {
                        Label("再调一杯", systemImage: "arrow.counterclockwise")
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

    private var gradeColor: Color {
        switch score.grade {
        case "S": Color(red: 0.98, green: 0.80, blue: 0.24)
        case "A": Color(red: 0.22, green: 0.82, blue: 0.48)
        case "B": Color(red: 0.48, green: 0.78, blue: 1.0)
        case "C": Color(red: 0.95, green: 0.60, blue: 0.24)
        default: Color(red: 0.95, green: 0.35, blue: 0.35)
        }
    }
}
