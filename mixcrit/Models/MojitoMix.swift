import SwiftUI

public struct MojitoMix {
    public var amounts: [String: Double] = [:]
    public var iceCount = 0
    public var shakeCount = 0
    public var actionCount = 0

    public var totalLiquid: Double {
        MojitoIngredient.allCases
            .filter { $0 != .mint }
            .reduce(0) { partial, ingredient in
                partial + amount(for: ingredient)
            }
    }

    public var mintLeaves: Int {
        Int(amount(for: .mint))
    }

    public var fillRatio: Double {
        min(totalLiquid / 190, 1)
    }

    public var liquidColor: Color {
        let rum = amount(for: .whiteRum)
        let lime = amount(for: .limeJuice)
        let syrup = amount(for: .syrup)
        let soda = amount(for: .soda)
        let total = max(rum + lime + syrup + soda, 1)

        let red = (0.78 * rum + 0.38 * lime + 0.94 * syrup + 0.66 * soda) / total
        let green = (0.96 * rum + 0.88 * lime + 0.76 * syrup + 0.92 * soda) / total
        let blue = (0.88 * rum + 0.38 * lime + 0.30 * syrup + 0.98 * soda) / total

        return Color(red: red, green: green, blue: blue)
    }

    public mutating func add(_ ingredient: MojitoIngredient) {
        amounts[ingredient.id, default: 0] += ingredient.stepAmount
        actionCount += 1
    }

    public mutating func pour(_ ingredient: MojitoIngredient) {
        amounts[ingredient.id, default: 0] += ingredient.pourAmount
        actionCount += 1
    }

    public mutating func add(_ ingredient: MojitoIngredient, amount: Double) {
        amounts[ingredient.id, default: 0] += amount
        actionCount += 1
    }

    public mutating func addIce() {
        iceCount += 1
        actionCount += 1
    }

    public mutating func shake() {
        shakeCount += 1
        actionCount += 1
    }

    public func amount(for ingredient: MojitoIngredient) -> Double {
        amounts[ingredient.id, default: 0]
    }
}

extension MojitoMix {
    public static var preview: MojitoMix {
        var mix = MojitoMix()
        mix.amounts[MojitoIngredient.whiteRum.id] = 45
        mix.amounts[MojitoIngredient.limeJuice.id] = 20
        mix.amounts[MojitoIngredient.syrup.id] = 15
        mix.amounts[MojitoIngredient.soda.id] = 90
        mix.amounts[MojitoIngredient.mint.id] = 8
        mix.iceCount = 6
        mix.shakeCount = 3
        return mix
    }
}
