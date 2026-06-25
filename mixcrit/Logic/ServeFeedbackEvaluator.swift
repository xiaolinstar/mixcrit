import Foundation

public enum ServeFeedbackEvaluator {
    public static func evaluate(_ state: SimplifiedMixState) -> ServeFeedback {
        let preferenceScore = scorePreference(state)
        let recipeScore = scoreRecipe(state)
        let techniqueScore = Int((state.techniqueRatio * 20).rounded())
        let speedScore = scoreSpeed(state.elapsedSeconds)
        let presentationScore = state.ice == .balanced ? 10 : 7
        let total = min(100, recipeScore + preferenceScore + techniqueScore + speedScore + presentationScore)
        let grade = grade(for: total)
        let tags = feedbackTags(for: state, total: total)

        return ServeFeedback(
            total: total,
            grade: grade,
            customerLine: customerLine(for: state, total: total),
            tags: tags,
            coins: max(8, total / 4),
            experience: max(5, total / 5),
            satisfaction: total
        )
    }

    private static func scoreRecipe(_ state: SimplifiedMixState) -> Int {
        var score = 25
        if state.rum == .low {
            score -= 4
        }
        if state.sweetness == .high, state.preference != .sweeter {
            score -= 3
        }
        if state.ice == .low {
            score -= 3
        }
        return max(0, score)
    }

    private static func scorePreference(_ state: SimplifiedMixState) -> Int {
        switch state.preference {
        case .refreshing:
            return score(matches: state.sweetness == .low || state.ice == .balanced)
        case .sweeter:
            return score(matches: state.sweetness == .high)
        case .mintForward:
            return score(matches: state.mint == .high)
        case .spiritForward:
            return score(matches: state.rum == .high)
        }
    }

    private static func score(matches: Bool) -> Int {
        matches ? 30 : 18
    }

    private static func scoreSpeed(_ seconds: TimeInterval) -> Int {
        switch seconds {
        case 0...40: 15
        case 40...75: 11
        default: 7
        }
    }

    private static func grade(for total: Int) -> String {
        switch total {
        case 90...100: "S"
        case 80..<90: "A"
        case 70..<80: "B"
        case 60..<70: "C"
        default: "D"
        }
    }

    private static func customerLine(for state: SimplifiedMixState, total: Int) -> String {
        if total >= 85 {
            return "这杯正好是我想要的感觉，入口很顺。"
        }

        switch state.preference {
        case .refreshing:
            return "清爽感有了，但甜度和冰感还可以再收一点。"
        case .sweeter:
            return "整体不错，不过甜感还没有完全托住青柠。"
        case .mintForward:
            return "薄荷香气有方向，但还可以再鲜明一点。"
        case .spiritForward:
            return "酒感能感到，但平衡还可以再稳一些。"
        }
    }

    private static func feedbackTags(for state: SimplifiedMixState, total: Int) -> [String] {
        var tags: [String] = []
        tags.append("偏好：\(state.preference.title)")
        tags.append(preferenceTag(for: state))
        tags.append(state.techniqueSteps >= 3 ? "手法：融合度好" : "手法：还可以多摇拌")
        tags.append(balanceTag(for: state))
        tags.append(total >= 80 ? "呈现：顾客满意" : "呈现：有进步空间")
        return tags
    }

    private static func preferenceTag(for state: SimplifiedMixState) -> String {
        switch state.preference {
        case .refreshing:
            return state.sweetness == .low ? "口味：清爽不腻" : "口味：甜感略重"
        case .sweeter:
            return state.sweetness == .high ? "口味：甜感柔和" : "口味：甜度偏轻"
        case .mintForward:
            return state.mint == .high ? "香气：薄荷突出" : "香气：薄荷偏弱"
        case .spiritForward:
            return state.rum == .high ? "酒感：更明确" : "酒感：略保守"
        }
    }

    private static func balanceTag(for state: SimplifiedMixState) -> String {
        let rum = MixControlKind.rum.optionTitle(for: state.rum)
        let syrup = MixControlKind.sweetness.optionTitle(for: state.sweetness)
        let mint = MixControlKind.mint.optionTitle(for: state.mint)

        if state.sweetness == .high, state.preference != .sweeter {
            return "复盘：\(syrup) 糖浆会压住青柠清爽感"
        }
        if state.rum == .high, state.preference != .spiritForward {
            return "复盘：\(rum) 白朗姆让酒感更抢"
        }
        if state.mint == .high {
            return "复盘：\(mint) 薄荷要拍香，避免捣碎出苦"
        }
        return "复盘：\(rum) 朗姆、\(syrup) 糖浆是经典平衡"
    }
}
