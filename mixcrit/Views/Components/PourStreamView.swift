import SwiftUI

public struct PourStreamView: View {
    public let ingredient: MojitoIngredient
    public let pulse: Bool

    public init(ingredient: MojitoIngredient, pulse: Bool) {
        self.ingredient = ingredient
        self.pulse = pulse
    }

    public var body: some View {
        VStack(spacing: 0) {
            BottlePourHead(ingredient: ingredient, pulse: pulse)
                .frame(width: 112, height: 72)
                .offset(x: -12, y: 12)

            ZStack {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                ingredient.tint.opacity(0.95),
                                ingredient.tint.opacity(0.42),
                                .white.opacity(0.20)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: ingredient == .mint ? 0 : 8, height: pulse ? 122 : 96)
                    .shadow(color: ingredient.tint.opacity(0.48), radius: 12)

                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(ingredient.tint.opacity(ingredient == .mint ? 0 : 0.62))
                        .frame(width: CGFloat(5 + index), height: CGFloat(5 + index))
                        .offset(
                            x: CGFloat(index - 2) * 7,
                            y: CGFloat(index * 22) + (pulse ? 14 : -6)
                        )
                        .opacity(pulse ? 0.95 : 0.45)
                }

                if ingredient == .mint {
                    ForEach(0..<5, id: \.self) { index in
                        Capsule()
                            .fill(ingredient.tint.opacity(0.90))
                            .frame(width: 9, height: 20)
                            .rotationEffect(.degrees(Double(index * 32)))
                            .offset(
                                x: CGFloat(index - 2) * 12,
                                y: CGFloat(index * 18) + (pulse ? 20 : 0)
                            )
                    }
                }
            }
            .frame(height: 138, alignment: .top)
        }
        .allowsHitTesting(false)
        .animation(.easeInOut(duration: 0.16), value: pulse)
    }
}
