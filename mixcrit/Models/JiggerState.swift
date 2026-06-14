import SwiftUI

public struct JiggerState {
    public var ingredientID: String?
    public var amount: Double = 0

    public let capacity: Double = 60
    public let marks: [Double] = [15, 30, 45, 60]

    public var fillRatio: Double {
        min(amount / capacity, 1)
    }

    public var isEmpty: Bool {
        amount <= 0
    }

    public var activeIngredient: MojitoIngredient? {
        guard let ingredientID else {
            return nil
        }

        return MojitoIngredient.allCases.first { $0.id == ingredientID }
    }

    public var nearestMark: Double? {
        marks.min { first, second in
            abs(first - amount) < abs(second - amount)
        }
    }

    public mutating func pour(_ ingredient: MojitoIngredient) {
        if ingredientID != ingredient.id {
            ingredientID = ingredient.id
            amount = 0
        }

        amount = min(capacity, amount + ingredient.pourAmount)
    }

    public mutating func snapToNearbyMark(threshold: Double = 1.6) -> Bool {
        guard let nearestMark, abs(amount - nearestMark) <= threshold else {
            return false
        }

        amount = nearestMark
        return true
    }

    public mutating func empty() {
        ingredientID = nil
        amount = 0
    }

    public init() {}
}
