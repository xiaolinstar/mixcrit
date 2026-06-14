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
            Label(title, systemImage: systemImage)
                .font((layout.isCompact ? Font.caption2 : Font.caption).weight(.black))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .frame(maxWidth: .infinity)
                .frame(height: layout.actionButtonHeight)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .foregroundStyle(.black)
    }
}
