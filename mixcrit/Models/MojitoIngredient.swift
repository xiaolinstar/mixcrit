import SwiftUI

public enum MojitoIngredient: String, CaseIterable, Identifiable {
    case whiteRum
    case limeJuice
    case syrup
    case soda
    case mint

    public var id: String { rawValue }

    public var name: String {
        switch self {
        case .whiteRum: "白朗姆"
        case .limeJuice: "青柠汁"
        case .syrup: "糖浆"
        case .soda: "苏打水"
        case .mint: "薄荷"
        }
    }

    public var icon: String {
        switch self {
        case .whiteRum: "drop.fill"
        case .limeJuice: "leaf.fill"
        case .syrup: "takeoutbag.and.cup.and.straw.fill"
        case .soda: "bubbles.and.sparkles.fill"
        case .mint: "camera.macro"
        }
    }

    public var targetAmount: Double {
        switch self {
        case .whiteRum: 45
        case .limeJuice: 15
        case .syrup: 15
        case .soda: 90
        case .mint: 8
        }
    }

    public var stepAmount: Double {
        switch self {
        case .mint: 2
        default: 5
        }
    }

    public var pourAmount: Double {
        switch self {
        case .soda: 6
        case .mint: 1
        default: 1.5
        }
    }

    public var usesJigger: Bool {
        switch self {
        case .whiteRum, .limeJuice, .syrup:
            true
        case .soda, .mint:
            false
        }
    }

    public var unit: String {
        switch self {
        case .mint: "片"
        default: "ml"
        }
    }

    public var tint: Color {
        switch self {
        case .whiteRum: Color(red: 0.85, green: 0.95, blue: 0.92)
        case .limeJuice: Color(red: 0.45, green: 0.90, blue: 0.38)
        case .syrup: Color(red: 0.96, green: 0.82, blue: 0.36)
        case .soda: Color(red: 0.62, green: 0.90, blue: 1.0)
        case .mint: Color(red: 0.18, green: 0.74, blue: 0.40)
        }
    }

    public var assetName: String {
        switch self {
        case .whiteRum:
            "bottle_white_rum"
        case .limeJuice:
            "bottle_lime_juice"
        case .syrup:
            "bottle_syrup"
        case .soda:
            "bottle_soda"
        case .mint:
            "mint_leaf"
        }
    }
}
