import SwiftUI

public enum CustomerPreference: String, CaseIterable, Identifiable {
    case refreshing
    case sweeter
    case mintForward
    case spiritForward

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .refreshing: "清爽一点"
        case .sweeter: "甜一点"
        case .mintForward: "薄荷重一点"
        case .spiritForward: "酒感强一点"
        }
    }

    public var orderLine: String {
        switch self {
        case .refreshing:
            "今晚想喝一杯清爽、不太甜的 Mojito。"
        case .sweeter:
            "今天想要一杯柔和一点、甜感明显的 Mojito。"
        case .mintForward:
            "想要薄荷香冲出来一点，越清新越好。"
        case .spiritForward:
            "想要酒感更明确，但不要压住青柠和薄荷。"
        }
    }

    public var tint: Color {
        switch self {
        case .refreshing: Color(red: 0.54, green: 0.90, blue: 0.84)
        case .sweeter: Color(red: 0.96, green: 0.76, blue: 0.34)
        case .mintForward: Color(red: 0.24, green: 0.78, blue: 0.42)
        case .spiritForward: Color(red: 0.88, green: 0.86, blue: 0.74)
        }
    }
}
