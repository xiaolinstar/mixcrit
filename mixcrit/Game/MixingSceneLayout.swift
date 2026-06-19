import CoreGraphics

public struct MixingSceneLayout {
    public let size: CGSize

    public init(size: CGSize) {
        self.size = size
    }

    public var padding: CGFloat {
        max(10, min(size.width, size.height) * 0.026)
    }

    public var stageRect: CGRect {
        CGRect(
            x: padding,
            y: padding,
            width: max(1, size.width - padding * 2),
            height: max(1, size.height - padding * 2)
        )
    }

    /// 成品杯是画面主角，尽量用满垂直空间；宽度上限做小屏保护，避免横向溢出。
    public var glassSize: CGSize {
        let height = min(stageRect.height * 0.90, stageRect.width * 1.04)
        return CGSize(width: height * 0.46, height: height)
    }

    /// 量杯略矮，与成品杯共用同一台面基线，形成站立在吧台上的真实关系。
    public var jiggerSize: CGSize {
        let height = min(glassSize.height * 0.74, stageRect.width * 0.78)
        return CGSize(width: height * 0.40, height: height)
    }

    /// 成品杯垂直居中略偏上，使顶部暗区收敛、底部留出台面与投影空间。
    public var glassCenter: CGPoint {
        CGPoint(
            x: stageRect.minX + stageRect.width * 0.71,
            y: stageRect.minY + stageRect.height * 0.50
        )
    }

    /// 深色舞台卡片只包裹杯具内容（杯顶上方一点到台面下方一点），避免上下出现大面积死黑暗区。
    public var cardRect: CGRect {
        let glassTop = glassCenter.y + glassSize.height * 0.5
        let top = min(stageRect.maxY, glassTop + glassSize.height * 0.12)
        let bottom = max(stageRect.minY, toolBaselineY - glassSize.height * 0.17)
        return CGRect(
            x: stageRect.minX,
            y: bottom,
            width: stageRect.width,
            height: max(1, top - bottom)
        )
    }

    /// 两件杯具底部对齐，量杯重心随之下沉，站在同一条台面线上。
    public var jiggerCenter: CGPoint {
        CGPoint(
            x: stageRect.minX + stageRect.width * 0.28,
            y: glassCenter.y - (glassSize.height - jiggerSize.height) * 0.5
        )
    }

    /// 台面基线取成品杯底，台面线、投影、背光都以此对齐。
    public var toolBaselineY: CGFloat {
        glassCenter.y - glassSize.height * 0.5
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
