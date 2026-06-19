import Foundation

public enum MixingWorkflowAction: Equatable {
    case ingredient(MojitoIngredient)
    case transferJigger
    case addIce
    case shake
    case serve
}

public struct MixingWorkflowStep: Equatable {
    public let title: String
    public let detail: String
    public let action: MixingWorkflowAction

    public static func current(mix: MojitoMix, jigger: JiggerState) -> MixingWorkflowStep {
        if let active = jigger.activeIngredient, jigger.amount > 0 {
            return MixingWorkflowStep(
                title: "量杯已装好",
                detail: "下一步：点「量杯入杯」，把 \(active.name) 15ml 倒进成品杯",
                action: .transferJigger
            )
        }

        if mix.amount(for: .whiteRum) < MojitoIngredient.whiteRum.targetAmount {
            return pourJiggerStep(for: .whiteRum, mix: mix)
        }

        if mix.amount(for: .limeJuice) < MojitoIngredient.limeJuice.targetAmount {
            return pourJiggerStep(for: .limeJuice, mix: mix)
        }

        if mix.amount(for: .syrup) < MojitoIngredient.syrup.targetAmount {
            return pourJiggerStep(for: .syrup, mix: mix)
        }

        if mix.amount(for: .soda) < MojitoIngredient.soda.targetAmount {
            return directPourStep(for: .soda, mix: mix)
        }

        if mix.amount(for: .mint) < MojitoIngredient.mint.targetAmount {
            return directPourStep(for: .mint, mix: mix)
        }

        if mix.iceCount < 6 {
            return MixingWorkflowStep(
                title: "加冰",
                detail: "下一步：点「加冰」，目标 6 颗（当前 \(mix.iceCount)/6）",
                action: .addIce
            )
        }

        if mix.shakeCount < 3 {
            return MixingWorkflowStep(
                title: "摇酒",
                detail: "下一步：点「摇酒」\(mix.shakeCount)/3 次，让味道融合",
                action: .shake
            )
        }

        return MixingWorkflowStep(
            title: "可以出杯",
            detail: "配方差不多了，点「出杯」查看评分",
            action: .serve
        )
    }

    private static func pourJiggerStep(for ingredient: MojitoIngredient, mix: MojitoMix) -> MixingWorkflowStep {
        let current = Int(mix.amount(for: ingredient))
        let target = Int(ingredient.targetAmount)
        let unit = Int(ingredient.stepAmount)
        let cyclesRemaining = max(1, Int(ceil(Double(target - current) / Double(unit))))

        let detail: String
        if current == 0, ingredient == .whiteRum {
            detail = "下一步：点白朗姆装 15ml → 点「量杯入杯」；重复 3 次到 45ml"
        } else if cyclesRemaining == 1 {
            detail = "下一步：点\(ingredient.name)装 15ml → 点「量杯入杯」（\(current)/\(target)ml）"
        } else {
            detail = "已加 \(current)/\(target)ml · 还需 \(cyclesRemaining) 次「装量杯→入杯」"
        }

        return MixingWorkflowStep(
            title: "准备\(ingredient.name)",
            detail: detail,
            action: .ingredient(ingredient)
        )
    }

    private static func directPourStep(for ingredient: MojitoIngredient, mix: MojitoMix) -> MixingWorkflowStep {
        let current = Int(mix.amount(for: ingredient))
        let target = Int(ingredient.targetAmount)
        let step = Int(ingredient.stepAmount)
        let unit = ingredient.unit
        let clicksRemaining = max(1, Int(ceil(Double(target - current) / Double(step))))

        let detail: String
        if ingredient == .soda {
            if current == 0 {
                detail = "下一步：点苏打水，每次 30ml，共 3 次到 90ml"
            } else {
                detail = "下一步：点苏打水 +30ml（\(current)/\(target)ml，还需约 \(clicksRemaining) 次）"
            }
        } else {
            if current == 0 {
                detail = "下一步：点薄荷，每次 2 片，共 4 次到 8 片"
            } else {
                detail = "下一步：点薄荷 +2 片（\(current)/\(target)\(unit)，还需约 \(clicksRemaining) 次）"
            }
        }

        return MixingWorkflowStep(
            title: ingredient == .soda ? "补苏打水" : "加入薄荷",
            detail: detail,
            action: .ingredient(ingredient)
        )
    }
}
