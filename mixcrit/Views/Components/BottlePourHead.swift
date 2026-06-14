import SwiftUI

public struct BottlePourHead: View {
    public let ingredient: MojitoIngredient
    public let pulse: Bool

    public init(ingredient: MojitoIngredient, pulse: Bool) {
        self.ingredient = ingredient
        self.pulse = pulse
    }

    public var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(ingredient.tint.opacity(0.72))
                .frame(width: 78, height: 34)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.25), lineWidth: 1)
                }

            RoundedRectangle(cornerRadius: 5)
                .fill(ingredient.tint.opacity(0.90))
                .frame(width: 36, height: 16)
                .offset(x: 28)
        }
        .rotationEffect(.degrees(ingredient == .mint ? -14 : -28))
        .offset(x: pulse ? 4 : 0)
        .shadow(color: .black.opacity(0.28), radius: 12, y: 6)
    }
}
