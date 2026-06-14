import SwiftUI

public struct BottleView: View {
    public let color: Color
    public let height: CGFloat

    public init(color: Color, height: CGFloat) {
        self.color = color
        self.height = height
    }

    public var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 5)
                .fill(color.opacity(0.8))
                .frame(width: 18, height: height * 0.28)
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.62))
                .frame(width: 44, height: height * 0.72)
                .overlay {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.white.opacity(0.24))
                        .frame(width: 28, height: height * 0.22)
                }
        }
        .overlay(alignment: .topLeading) {
            Capsule()
                .fill(.white.opacity(0.22))
                .frame(width: 8, height: height * 0.55)
                .padding(.leading, 10)
                .padding(.top, 12)
        }
    }
}
