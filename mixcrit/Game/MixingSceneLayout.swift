import CoreGraphics

public struct MixingSceneLayout {
    public let size: CGSize

    public init(size: CGSize) {
        self.size = size
    }

    public var padding: CGFloat {
        max(14, min(size.width, size.height) * 0.035)
    }

    public var stageRect: CGRect {
        CGRect(
            x: padding,
            y: padding,
            width: max(1, size.width - padding * 2),
            height: max(1, size.height - padding * 2)
        )
    }

    public var counterRect: CGRect {
        let rect = stageRect
        return CGRect(
            x: rect.minX + rect.width * 0.05,
            y: rect.minY + rect.height * 0.08,
            width: rect.width * 0.90,
            height: rect.height * 0.24
        )
    }

    public var toolBaselineY: CGFloat {
        counterRect.maxY + stageRect.height * 0.08
    }

    public var jiggerSize: CGSize {
        let height = min(stageRect.height * 0.52, stageRect.width * 0.60)
        return CGSize(width: height * 0.34, height: height)
    }

    public var glassSize: CGSize {
        let height = min(stageRect.height * 0.50, stageRect.width * 0.56)
        return CGSize(width: height * 0.42, height: height)
    }

    public var jiggerCenter: CGPoint {
        CGPoint(
            x: stageRect.minX + stageRect.width * 0.25,
            y: toolBaselineY + jiggerSize.height * 0.50
        )
    }

    public var glassCenter: CGPoint {
        CGPoint(
            x: stageRect.minX + stageRect.width * 0.68,
            y: toolBaselineY + glassSize.height * 0.50
        )
    }

    public var pourStart: CGPoint {
        CGPoint(
            x: jiggerCenter.x,
            y: jiggerCenter.y + jiggerSize.height * 0.54
        )
    }

    public var glassPourTarget: CGPoint {
        CGPoint(
            x: glassCenter.x,
            y: glassCenter.y + glassSize.height * 0.42
        )
    }
}
