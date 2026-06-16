import SwiftUI

public struct BarIngredientObjectView: View {
    public let ingredient: MojitoIngredient
    public let amount: Double
    public let isSelected: Bool
    public let isActive: Bool
    public let layout: ScreenLayout
    public let onSelect: () -> Void
    public let onStart: () -> Void
    public let onStop: () -> Void

    public init(
        ingredient: MojitoIngredient,
        amount: Double,
        isSelected: Bool,
        isActive: Bool,
        layout: ScreenLayout,
        onSelect: @escaping () -> Void,
        onStart: @escaping () -> Void,
        onStop: @escaping () -> Void
    ) {
        self.ingredient = ingredient
        self.amount = amount
        self.isSelected = isSelected
        self.isActive = isActive
        self.layout = layout
        self.onSelect = onSelect
        self.onStart = onStart
        self.onStop = onStop
    }

    private var artworkHeight: CGFloat { layout.ingredientRowHeight * 0.78 }
    private var artworkWidth: CGFloat { layout.ingredientRowHeight * 0.72 }

    public var body: some View {
        VStack(spacing: layout.isUltraCompact ? 0 : 2) {
            ingredientArtwork
                .frame(width: artworkWidth, height: artworkHeight)

            VStack(spacing: 1) {
                Text(ingredient.name)
                    .font(.system(size: max(9, 11 * layout.scale), weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                HStack(spacing: 3) {
                    Text("已加 \(Int(amount))\(ingredient.unit)")
                        .foregroundStyle(ingredient.tint)
                    Text("目标 \(Int(ingredient.targetAmount))\(ingredient.unit)")
                        .foregroundStyle(.white.opacity(0.58))
                }
                .font(.system(size: max(7, 8 * layout.scale), weight: .semibold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.55)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .padding(.vertical, layout.isUltraCompact ? 2 : 3)
        .background(
            LinearGradient(
                colors: [
                    .white.opacity(isSelected ? 0.20 : 0.08),
                    ingredient.tint.opacity(isSelected ? 0.24 : 0.07)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(ingredient.tint.opacity(isSelected ? 0.85 : 0.25), lineWidth: isSelected ? 2 : 1)
        }
        .shadow(color: ingredient.tint.opacity(isActive ? 0.35 : 0.08), radius: isActive ? 10 : 3, y: 3)
        .scaleEffect(isActive ? 0.97 : 1)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
            onStart()
        }
    }

    @ViewBuilder
    private var ingredientArtwork: some View {
        Image(ingredient.assetName)
            .resizable()
            .scaledToFit()
            .shadow(color: .black.opacity(0.22), radius: 4, y: 2)
    }
}

public struct IceBucketObjectView: View {
    public let count: Int
    public let layout: ScreenLayout
    public let onAddIce: () -> Void

    public init(count: Int, layout: ScreenLayout, onAddIce: @escaping () -> Void) {
        self.count = count
        self.layout = layout
        self.onAddIce = onAddIce
    }

    private var bucketWidth: CGFloat { layout.ingredientRowHeight * 0.52 }
    private var bucketHeight: CGFloat { layout.ingredientRowHeight * 0.40 }

    public var body: some View {
        Button(action: onAddIce) {
            VStack(spacing: layout.isUltraCompact ? 2 : 4) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.76, blue: 0.86).opacity(0.55),
                                    Color(red: 0.20, green: 0.28, blue: 0.34).opacity(0.82)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: bucketWidth, height: bucketHeight)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white.opacity(0.24), lineWidth: 1)
                        }

                    HStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { index in
                            Image("ice_cube")
                                .resizable()
                                .scaledToFit()
                                .frame(width: bucketWidth * 0.28, height: bucketWidth * 0.28)
                                .rotationEffect(.degrees(Double(index * 14 - 10)))
                        }
                    }
                    .offset(y: -bucketHeight * 0.48)
                }
                .frame(height: layout.ingredientRowHeight * 0.58)

                VStack(spacing: 1) {
                    Text("冰桶")
                        .font(.caption2.weight(.black))
                    Text("\(count)/6 颗")
                        .font(.system(size: max(8, 10 * layout.scale), weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.56))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.64, green: 0.88, blue: 1.0).opacity(0.34), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
