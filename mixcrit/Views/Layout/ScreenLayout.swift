import SwiftUI

/// 基于可用屏幕尺寸计算各区域高度与缩放比例，保证单屏完整显示。
public struct ScreenLayout {
    public let size: CGSize
    public let safeArea: EdgeInsets

    public init(size: CGSize, safeArea: EdgeInsets = .init()) {
        self.size = size
        self.safeArea = safeArea
    }

    public enum Tier {
        case ultraCompact
        case compact
        case regular
    }

    public var contentHeight: CGFloat {
        size.height - safeArea.top - safeArea.bottom
    }

    public var contentWidth: CGFloat {
        size.width - safeArea.leading - safeArea.trailing
    }

    /// 以 iPhone 15 竖屏（约 740pt 可用高度）为基准。
    public var scale: CGFloat {
        min(1, max(0.72, contentHeight / 740))
    }

    public var tier: Tier {
        if contentHeight < 620 {
            return .ultraCompact
        }
        if contentHeight < 720 {
            return .compact
        }
        return .regular
    }

    public var isCompact: Bool { tier != .regular }
    public var isUltraCompact: Bool { tier == .ultraCompact }

    public var horizontalPadding: CGFloat { 10 + 6 * scale }
    public var sectionSpacing: CGFloat { max(3, 6 * scale) }
    public var verticalPadding: CGFloat { max(1, 4 * scale) }

    public var actionRowSpacing: CGFloat {
        max(3, 4 * scale)
    }

    public var orderCardHeight: CGFloat {
        if isUltraCompact {
            return 58
        }
        if isCompact {
            return 66
        }
        return 78
    }

    public var controlDockHeight: CGFloat {
        ingredientRowHeight + actionButtonHeight * 2 + actionRowSpacing * 2 + dockTopPadding
    }

    public var actionButtonHeight: CGFloat { max(24, 28 * scale) }
    public var secondaryButtonHeight: CGFloat { max(20, 22 * scale) }

    public var ingredientRowHeight: CGFloat {
        if isUltraCompact {
            return min(82, max(72, 98 * scale))
        }
        if isCompact {
            return min(96, max(84, 104 * scale))
        }
        return min(108, max(96, 108 * scale))
    }

    public var dockTopPadding: CGFloat {
        max(4, 6 * scale)
    }

    public var stageMinHeight: CGFloat {
        isUltraCompact ? 260 : 300
    }

    public var titleFontSize: CGFloat { max(28, 46 * scale) }
    public var gradeFontSize: CGFloat { max(52, 78 * scale) }
}
