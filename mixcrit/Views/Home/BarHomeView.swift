import SwiftUI

public struct BarHomeView: View {
    let onStart: () -> Void

    public init(onStart: @escaping () -> Void) {
        self.onStart = onStart
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = ScreenLayout(size: proxy.size, safeArea: proxy.safeAreaInsets)

            VStack(spacing: layout.sectionSpacing * 2) {
                Spacer(minLength: 0)

                VStack(spacing: max(6, 12 * layout.scale)) {
                    Text("MIXCRIT")
                        .font(.system(size: layout.titleFontSize, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(red: 0.95, green: 0.76, blue: 0.36)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text("P0: Mojito 调酒台原型")
                        .font((layout.isCompact ? Font.subheadline : Font.headline).weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                BarCounterPreview(layout: layout)
                    .frame(height: layout.contentHeight * 0.34)
                    .padding(.horizontal, layout.horizontalPadding)

                VStack(spacing: max(8, 10 * layout.scale)) {
                    Text("今晚第一位客人想要一杯清爽、有薄荷香、不要太甜的 Mojito。")
                        .font(layout.isCompact ? .subheadline : .body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.82))
                        .lineLimit(layout.isUltraCompact ? 2 : 3)
                        .minimumScaleFactor(0.85)
                        .padding(.horizontal, layout.horizontalPadding + 8)

                    Button(action: onStart) {
                        Label("开始营业", systemImage: "wineglass.fill")
                            .font((layout.isCompact ? Font.subheadline : Font.headline).weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, max(12, 16 * layout.scale))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.15, green: 0.68, blue: 0.40))
                    .padding(.horizontal, layout.horizontalPadding + 12)
                }

                Spacer(minLength: 0)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .padding(.top, layout.verticalPadding)
            .padding(.bottom, layout.verticalPadding)
        }
    }
}
