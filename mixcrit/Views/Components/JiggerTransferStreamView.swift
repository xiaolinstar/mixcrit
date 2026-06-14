import SwiftUI

public struct JiggerTransferStreamView: View {
    public let ingredient: MojitoIngredient

    public init(ingredient: MojitoIngredient) {
        self.ingredient = ingredient
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ingredient.tint.opacity(0.48))
                .frame(width: 72, height: 24)
                .rotationEffect(.degrees(-24))
                .offset(x: -36, y: -38)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.22), lineWidth: 1)
                        .rotationEffect(.degrees(-24))
                        .offset(x: -36, y: -38)
                }

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            ingredient.tint.opacity(0.90),
                            ingredient.tint.opacity(0.32)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 10, height: 116)
                .rotationEffect(.degrees(-22))
                .offset(x: 12, y: 10)
                .shadow(color: ingredient.tint.opacity(0.45), radius: 12)
        }
        .allowsHitTesting(false)
    }
}
