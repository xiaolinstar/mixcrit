import Foundation

public enum MixDial: Int, CaseIterable, Identifiable {
    case low
    case balanced
    case high

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .low: "轻"
        case .balanced: "标准"
        case .high: "重"
        }
    }
}

public enum MixControlKind {
    case rum
    case sweetness
    case mint
    case ice

    public var title: String {
        switch self {
        case .rum: "白朗姆"
        case .sweetness: "糖浆"
        case .mint: "薄荷"
        case .ice: "冰块"
        }
    }

    public func optionTitle(for dial: MixDial) -> String {
        switch self {
        case .rum: rumOptionTitle(for: dial)
        case .sweetness: sweetnessOptionTitle(for: dial)
        case .mint: mintOptionTitle(for: dial)
        case .ice: iceOptionTitle(for: dial)
        }
    }

    public func lesson(for dial: MixDial) -> String {
        switch self {
        case .rum: rumLesson(for: dial)
        case .sweetness: sweetnessLesson(for: dial)
        case .mint: mintLesson(for: dial)
        case .ice: iceLesson(for: dial)
        }
    }

    private func rumOptionTitle(for dial: MixDial) -> String {
        switch dial {
        case .low: "35ml"
        case .balanced: "45ml"
        case .high: "55ml"
        }
    }

    private func sweetnessOptionTitle(for dial: MixDial) -> String {
        switch dial {
        case .low: "8ml"
        case .balanced: "15ml"
        case .high: "24ml"
        }
    }

    private func mintOptionTitle(for dial: MixDial) -> String {
        switch dial {
        case .low: "4片"
        case .balanced: "8片"
        case .high: "12片"
        }
    }

    private func iceOptionTitle(for dial: MixDial) -> String {
        switch dial {
        case .low: "3块"
        case .balanced: "6块"
        case .high: "8块"
        }
    }

    private func rumLesson(for dial: MixDial) -> String {
        switch dial {
        case .low: "酒体更轻，适合想要清爽、低负担的客人。"
        case .balanced: "经典 Mojito 常用约 45ml 白朗姆，酒感和青柠更平衡。"
        case .high: "酒感更突出，但过量会压住薄荷和青柠的清新。"
        }
    }

    private func sweetnessLesson(for dial: MixDial) -> String {
        switch dial {
        case .low: "糖浆少，酸度更明显，整体更干爽。"
        case .balanced: "约 15ml 糖浆能托住青柠酸度，是常见平衡点。"
        case .high: "甜感更柔和，但太多会让 Mojito 变腻。"
        }
    }

    private func mintLesson(for dial: MixDial) -> String {
        switch dial {
        case .low: "薄荷较少，香气轻，适合不想草本味太强的客人。"
        case .balanced: "拍香后加入约 8 片薄荷，能提供清新的主体香气。"
        case .high: "薄荷香更鲜明，但需要避免捣碎出苦味。"
        }
    }

    private func iceLesson(for dial: MixDial) -> String {
        switch dial {
        case .low: "冰少会降温慢、稀释少，清爽感不足。"
        case .balanced: "足量冰块能快速降温，并控制 Mojito 的稀释速度。"
        case .high: "冰量更足更清凉，但会加快稀释。"
        }
    }
}
public struct SimplifiedMixState {
    public var preference: CustomerPreference
    public var rum: MixDial = .balanced
    public var sweetness: MixDial = .balanced
    public var mint: MixDial = .balanced
    public var ice: MixDial = .balanced
    public var techniqueSteps = 0
    public var startedAt = Date()

    public var elapsedSeconds: TimeInterval {
        max(0, Date().timeIntervalSince(startedAt))
    }

    public var techniqueRatio: Double {
        min(Double(techniqueSteps) / 3, 1)
    }

    public var previewMix: MojitoMix {
        var mix = MojitoMix()
        mix.amounts[MojitoIngredient.whiteRum.id] = rum.amount(low: 35, balanced: 45, high: 55)
        mix.amounts[MojitoIngredient.limeJuice.id] = 15
        mix.amounts[MojitoIngredient.syrup.id] = sweetness.amount(low: 8, balanced: 15, high: 24)
        mix.amounts[MojitoIngredient.soda.id] = preference == .refreshing ? 100 : 90
        mix.amounts[MojitoIngredient.mint.id] = mint.amount(low: 4, balanced: 8, high: 12)
        mix.iceCount = Int(ice.amount(low: 3, balanced: 6, high: 8))
        mix.shakeCount = techniqueSteps
        mix.actionCount = 5 + techniqueSteps
        return mix
    }

    public init(preference: CustomerPreference = .refreshing) {
        self.preference = preference
    }
}

extension MixDial {
    public func amount(low: Double, balanced: Double, high: Double) -> Double {
        switch self {
        case .low: low
        case .balanced: balanced
        case .high: high
        }
    }
}
