import SwiftUI

public struct ActionButton: View {
    public let title: String
    public let systemImage: String
    public let tint: Color
    public let layout: ScreenLayout
    public let action: () -> Void

    public init(title: String, systemImage: String, tint: Color, layout: ScreenLayout, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.layout = layout
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
            .background(tint.opacity(0.30), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(0.28), lineWidth: 0.8)
            }
            .overlay(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(tint.opacity(0.42), lineWidth: 1)
                    .blendMode(.plusLighter)
            }
            .shadow(color: tint.opacity(0.18), radius: 8, y: 4)
            .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
