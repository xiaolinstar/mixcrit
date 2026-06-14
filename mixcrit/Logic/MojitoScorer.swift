import SwiftUI

public enum MojitoScorer {
    public static func score(_ mix: MojitoMix) -> MojitoScore {
        var points = 0.0
        var feedback: [String] = []

        let amountScore = MojitoIngredient.allCases.reduce(0.0) { partial, ingredient in
            let actual = mix.amount(for: ingredient)
            let target = ingredient.targetAmount
            let difference = abs(actual - target)
            let maxIngredientScore = 60.0 / Double(MojitoIngredient.allCases.count)
            let ingredientScore = max(0, maxIngredientScore * (1 - difference / max(target, 1)))

            if actual == 0 {
                feedback.append("缺少\(ingredient.name)，Mojito 的结构不完整。")
            } else if difference <= 5 || (ingredient == .mint && difference <= 2) {
                feedback.append("\(ingredient.name)用量很接近目标。")
            } else if actual > target {
                feedback.append("\(ingredient.name)偏多，风味会被拉偏。")
            } else {
                feedback.append("\(ingredient.name)偏少，层次会变弱。")
            }

            return partial + ingredientScore
        }

        points += amountScore

        let iceDifference = abs(mix.iceCount - 6)
        points += max(0, 10 - Double(iceDifference) * 2)
        if mix.iceCount == 0 {
            feedback.append("没有加冰，清爽度和温度都会不足。")
        } else if iceDifference <= 1 {
            feedback.append("冰块数量合适，口感会比较清爽。")
        } else if mix.iceCount > 6 {
            feedback.append("冰块偏多，饮品容易被过度稀释。")
        } else {
            feedback.append("冰块偏少，降温不足。")
        }

        points += min(Double(mix.shakeCount) / 3, 1) * 15
        if mix.shakeCount >= 3 {
            feedback.append("摇酒完成度不错，薄荷和青柠香气被带出来了。")
        } else {
            feedback.append("摇酒不足，香气和融合度还可以更好。")
        }

        let completedIngredients = MojitoIngredient.allCases.filter { mix.amount(for: $0) > 0 }.count
        points += Double(completedIngredients) / Double(MojitoIngredient.allCases.count) * 10
        points += mix.actionCount > 0 ? 5 : 0

        let total = min(100, max(0, Int(points.rounded())))
        let grade: String
        switch total {
        case 90...100: grade = "S"
        case 80..<90: grade = "A"
        case 70..<80: grade = "B"
        case 60..<70: grade = "C"
        default: grade = "D"
        }

        return MojitoScore(total: total, grade: grade, feedback: Array(feedback.prefix(5)))
    }
}
