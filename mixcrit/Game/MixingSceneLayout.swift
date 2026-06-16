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

    public var toolBaselineY: CGFloat {
        stageRect.minY + stageRect.height * 0.17
    }

    public var jiggerSize: CGSize {
        let height = min(stageRect.height * 0.76, stageRect.width * 0.84)
        return CGSize(width: height * 0.38, height: height)
    }

    public var glassSize: CGSize {
        let height = min(stageRect.height * 0.78, stageRect.width * 0.84)
        return CGSize(width: height * 0.46, height: height)
    }

    public var jiggerCenter: CGPoint {
        CGPoint(
            x: stageRect.minX + stageRect.width * 0.32,
            y: toolBaselineY + jiggerSize.height * 0.50
        )
    }

    public var glassCenter: CGPoint {
        CGPoint(
            x: stageRect.minX + stageRect.width * 0.70,
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
