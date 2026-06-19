import SwiftUI

public struct ActionButton: View {
    public let title: String
    public let systemImage: String
    public let tint: Color
    public let layout: ScreenLayout
    public let isRecommended: Bool
    public let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        tint: Color,
        layout: ScreenLayout,
        isRecommended: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.layout = layout
        self.isRecommended = isRecommended
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: max(2, 3 * layout.scale)) {
                Image(systemName: systemImage)
                    .font(.system(size: max(13, 16 * layout.scale), weight: .black))
                Text(title)
                    .font(.system(size: max(8, 9.5 * layout.scale), weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.58)
            }
            .frame(maxWidth: .infinity)
            .frame(height: layout.actionButtonHeight)
            .foregroundStyle(.white)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .background(tint.opacity(isRecommended ? 0.48 : 0.30), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(isRecommended ? 0.58 : 0.28), lineWidth: isRecommended ? 1.2 : 0.8)
            }
            .overlay(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(tint.opacity(isRecommended ? 0.88 : 0.42), lineWidth: isRecommended ? 1.5 : 1)
                    .blendMode(.plusLighter)
            }
            .shadow(color: tint.opacity(isRecommended ? 0.42 : 0.18), radius: isRecommended ? 14 : 8, y: 4)
            .scaleEffect(isRecommended ? 1.035 : 1)
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
