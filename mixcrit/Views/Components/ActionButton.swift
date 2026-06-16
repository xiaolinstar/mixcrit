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
            HStack(spacing: max(4, 6 * layout.scale)) {
                Image(systemName: systemImage)
                    .font(.system(size: max(11, 13 * layout.scale), weight: .black))
                Text(title)
                    .font(.system(size: max(10, 12 * layout.scale), weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .frame(maxWidth: .infinity)
            .frame(height: layout.actionButtonHeight)
            .foregroundStyle(.black)
            .background(tint, in: RoundedRectangle(cornerRadius: 8))
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
