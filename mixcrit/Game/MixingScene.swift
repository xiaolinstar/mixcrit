import SpriteKit
import UIKit

public final class MixingScene: SKScene {
    private var currentState: MixingSceneState?

    private let stageNode = SKShapeNode()
    private let ambientGlowNode = SKShapeNode()
    private let glowNode = SKShapeNode()
    private let surfaceNode = SKShapeNode()
    private let jiggerShadowNode = SKShapeNode()
    private let glassShadowNode = SKShapeNode()
    private let transferArrowNode = SKShapeNode()
    private let jiggerGroup = SKNode()
    private let jiggerFeedbackNode = SKShapeNode()
    private let jiggerImageNode = SKSpriteNode(imageNamed: "jigger_empty")
    private let jiggerLiquidNode = SKShapeNode()
    private let glassGroup = SKNode()
    private let glassImageNode = SKSpriteNode(imageNamed: "highball_glass_empty")
    private let glassLiquidDepthNode = SKShapeNode()
    private let glassLiquidNode = SKShapeNode()
    private let glassSurfaceNode = SKShapeNode()
    private let glassLiquidHighlightNode = SKShapeNode()
    private let glassShineNode = SKShapeNode()
    private let serveGlowNode = SKShapeNode()
    private let iceLayerNode = SKNode()
    private let limeLayerNode = SKNode()
    private let mintLayerNode = SKNode()
    private let bubbleLayerNode = SKNode()
    private let transferGuideNode = SKShapeNode()
    private let pourStreamNode = SKShapeNode()
    private let transferStreamNode = SKShapeNode()
    private let streamParticleLayerNode = SKNode()
    private let streamImpactNode = SKShapeNode()
    private var lastRenderedJiggerAmount: Double = 0
    private var lastRenderedJiggerIngredientID: String?
    private var lastRenderedIceCount: Int = 0
    private var lastRenderedGlassFill: Double = 0
    private var hasRenderedOnce = false

    public override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    public override func didMove(to view: SKView) {
        view.allowsTransparency = true
        view.backgroundColor = .clear
        buildNodesIfNeeded()
        layoutNodes()
        if let currentState {
            render(currentState, animated: false)
        }
    }

    public override func didChangeSize(_ oldSize: CGSize) {
        layoutNodes()
        if let currentState {
            render(currentState, animated: false)
        }
    }

    public func update(with state: MixingSceneState) {
        let shouldAnimate = currentState != nil
        currentState = state
        buildNodesIfNeeded()
        layoutNodes()
        render(state, animated: shouldAnimate)
    }

    private func buildNodesIfNeeded() {
        guard stageNode.parent == nil else {
            return
        }

        addChild(stageNode)
        addChild(ambientGlowNode)
        addChild(glowNode)
        addChild(surfaceNode)
        addChild(transferGuideNode)
        addChild(transferArrowNode)
        addChild(jiggerShadowNode)
        addChild(glassShadowNode)
        addChild(jiggerGroup)
        addChild(glassGroup)
        addChild(pourStreamNode)
        addChild(transferStreamNode)
        addChild(streamParticleLayerNode)
        addChild(streamImpactNode)

        jiggerGroup.addChild(jiggerFeedbackNode)
        jiggerGroup.addChild(jiggerLiquidNode)
        jiggerGroup.addChild(jiggerImageNode)

        glassGroup.addChild(serveGlowNode)
        glassGroup.addChild(glassLiquidDepthNode)
        glassGroup.addChild(glassLiquidNode)
        glassGroup.addChild(glassSurfaceNode)
        glassGroup.addChild(glassLiquidHighlightNode)
        glassGroup.addChild(bubbleLayerNode)
        glassGroup.addChild(limeLayerNode)
        glassGroup.addChild(iceLayerNode)
        glassGroup.addChild(mintLayerNode)
        glassGroup.addChild(glassShineNode)
        glassGroup.addChild(glassImageNode)

        stageNode.zPosition = 0
        ambientGlowNode.zPosition = 1
        glowNode.zPosition = 2
        surfaceNode.zPosition = 2
        transferGuideNode.zPosition = 3
        transferArrowNode.zPosition = 3
        jiggerShadowNode.zPosition = 3
        glassShadowNode.zPosition = 3
        jiggerGroup.zPosition = 4
        glassGroup.zPosition = 4
        pourStreamNode.zPosition = 7
        transferStreamNode.zPosition = 7
        streamParticleLayerNode.zPosition = 8
        streamImpactNode.zPosition = 8

        jiggerImageNode.alpha = 0.92
        jiggerFeedbackNode.isHidden = true
        glassImageNode.alpha = 0.96
        serveGlowNode.isHidden = true
        serveGlowNode.zPosition = 0
        glassLiquidDepthNode.zPosition = 0
        glassLiquidNode.zPosition = 1
        glassSurfaceNode.zPosition = 2
        glassLiquidHighlightNode.zPosition = 3
        glassShineNode.lineCap = .round
        transferGuideNode.lineCap = .round
        pourStreamNode.lineCap = .round
        transferStreamNode.lineCap = .round
        streamImpactNode.isHidden = true
    }

    private func layoutNodes() {
        let layout = MixingSceneLayout(size: size)
        let cardRect = layout.cardRect

        stageNode.path = CGPath(
            roundedRect: cardRect,
            cornerWidth: max(20, cardRect.width * 0.055),
            cornerHeight: max(20, cardRect.width * 0.055),
            transform: nil
        )
        stageNode.fillColor = UIColor(red: 0.055, green: 0.052, blue: 0.046, alpha: 0.98)
        stageNode.strokeColor = UIColor(red: 0.86, green: 0.73, blue: 0.52, alpha: 0.16)
        stageNode.lineWidth = 1

        ambientGlowNode.path = CGPath(ellipseIn: CGRect(
            x: layout.glassCenter.x - cardRect.width * 0.40,
            y: layout.glassCenter.y - cardRect.height * 0.30,
            width: cardRect.width * 0.80,
            height: cardRect.height * 0.62
        ), transform: nil)
        ambientGlowNode.fillColor = UIColor(red: 0.95, green: 0.78, blue: 0.45, alpha: 0.05)
        ambientGlowNode.strokeColor = .clear

        glowNode.path = CGPath(ellipseIn: CGRect(
            x: layout.glassCenter.x - cardRect.width * 0.30,
            y: layout.glassCenter.y + layout.glassSize.height * 0.30,
            width: cardRect.width * 0.60,
            height: cardRect.height * 0.16
        ), transform: nil)
        glowNode.fillColor = UIColor(white: 1, alpha: 0.05)
        glowNode.strokeColor = .clear

        let surfaceY = layout.toolBaselineY - cardRect.height * 0.02
        surfaceNode.path = CGPath(
            roundedRect: CGRect(
                x: cardRect.minX + cardRect.width * 0.08,
                y: surfaceY,
                width: cardRect.width * 0.84,
                height: max(1.2, cardRect.height * 0.008)
            ),
            cornerWidth: 2,
            cornerHeight: 2,
            transform: nil
        )
        surfaceNode.fillColor = UIColor(white: 1, alpha: 0.09)
        surfaceNode.strokeColor = .clear

        layoutShadow(
            node: jiggerShadowNode,
            center: CGPoint(x: layout.jiggerCenter.x, y: surfaceY + cardRect.height * 0.006),
            width: layout.jiggerSize.width * 1.35,
            height: layout.jiggerSize.height * 0.075,
            alpha: 0.30
        )
        layoutShadow(
            node: glassShadowNode,
            center: CGPoint(x: layout.glassCenter.x, y: surfaceY + cardRect.height * 0.006),
            width: layout.glassSize.width * 1.70,
            height: layout.glassSize.height * 0.07,
            alpha: 0.26
        )

        jiggerGroup.position = layout.jiggerCenter
        glassGroup.position = layout.glassCenter
        layoutJigger(size: layout.jiggerSize)
        layoutGlass(size: layout.glassSize)
    }

    private func layoutShadow(node: SKShapeNode, center: CGPoint, width: CGFloat, height: CGFloat, alpha: CGFloat) {
        node.path = CGPath(
            ellipseIn: CGRect(
                x: center.x - width / 2,
                y: center.y - height / 2,
                width: width,
                height: height
            ),
            transform: nil
        )
        node.fillColor = UIColor(white: 0, alpha: alpha)
        node.strokeColor = .clear
    }

    private func layoutJigger(size: CGSize) {
        let feedbackRect = CGRect(
            x: -size.width * 0.60,
            y: -size.height * 0.45,
            width: size.width * 1.20,
            height: size.height * 0.90
        )
        jiggerFeedbackNode.path = CGPath(
            roundedRect: feedbackRect,
            cornerWidth: size.width * 0.26,
            cornerHeight: size.width * 0.26,
            transform: nil
        )
        jiggerFeedbackNode.fillColor = UIColor(white: 1, alpha: 0.035)
        jiggerFeedbackNode.strokeColor = UIColor(red: 0.94, green: 0.78, blue: 0.46, alpha: 0.70)
        jiggerFeedbackNode.lineWidth = max(1.2, size.width * 0.024)
        jiggerFeedbackNode.zPosition = 1

        jiggerImageNode.size = CGSize(width: size.width * 1.30, height: size.height * 0.84)
        jiggerImageNode.position = CGPoint(x: 0, y: -size.height * 0.02)
        jiggerImageNode.zPosition = 3
    }

    private func layoutGlass(size: CGSize) {
        glassImageNode.size = CGSize(width: size.width * 1.08, height: size.height * 1.08)
        glassImageNode.position = .zero
        glassImageNode.zPosition = 4

        serveGlowNode.path = CGPath(ellipseIn: CGRect(
            x: -size.width * 0.85,
            y: -size.height * 0.55,
            width: size.width * 1.70,
            height: size.height * 1.20
        ), transform: nil)
        serveGlowNode.fillColor = UIColor(red: 1.0, green: 0.86, blue: 0.46, alpha: 0.9)
        serveGlowNode.strokeColor = .clear
        serveGlowNode.alpha = 0

        let shinePath = CGMutablePath()
        shinePath.move(to: CGPoint(x: -size.width * 0.30, y: size.height * 0.27))
        shinePath.addLine(to: CGPoint(x: -size.width * 0.24, y: -size.height * 0.26))
        glassShineNode.path = shinePath
        glassShineNode.strokeColor = UIColor(white: 1, alpha: 0.30)
        glassShineNode.lineWidth = max(2, size.width * 0.035)
        glassShineNode.zPosition = 5
    }

    private func render(_ state: MixingSceneState, animated: Bool) {
        renderJigger(state, animated: animated)
        renderGlass(state, animated: animated)
        renderTransferGuide(state)
        renderStreams(state)
        renderShake(state)
        renderServe(state)
        hasRenderedOnce = true
    }

    private func renderServe(_ state: MixingSceneState) {
        guard state.isServing else {
            return
        }
        guard glassGroup.action(forKey: "serve") == nil else {
            return
        }
        runServeCelebration()
    }

    /// 出杯一瞬的完成仪式感：成品杯被金色高光托起、轻轻抬升再回落。
    private func runServeCelebration() {
        serveGlowNode.removeAllActions()
        serveGlowNode.isHidden = false
        serveGlowNode.alpha = 0
        serveGlowNode.setScale(0.7)

        let glow = SKAction.sequence([
            SKAction.group([
                SKAction.fadeAlpha(to: 0.5, duration: 0.14),
                SKAction.scale(to: 1.08, duration: 0.18)
            ]),
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.34),
                SKAction.scale(to: 1.22, duration: 0.34)
            ]),
            SKAction.hide()
        ])
        serveGlowNode.run(glow)

        let baseY = MixingSceneLayout(size: size).glassCenter.y
        let lift = SKAction.sequence([
            SKAction.moveTo(y: baseY + size.height * 0.03, duration: 0.16),
            SKAction.moveTo(y: baseY, duration: 0.22)
        ])
        lift.timingMode = .easeOut
        let pop = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 0.16),
            SKAction.scale(to: 1.0, duration: 0.22)
        ])
        glassGroup.run(SKAction.group([lift, pop]), withKey: "serve")
    }

    private func renderJigger(_ state: MixingSceneState, animated: Bool) {
        let layout = MixingSceneLayout(size: size)
        let jiggerSize = layout.jiggerSize
        let fillRatio = CGFloat(min(max(state.jiggerAmount / max(state.jiggerCapacity, 1), 0), 1))
        let liquidRect = CGRect(
            x: -jiggerSize.width * 0.26,
            y: jiggerSize.height * 0.21,
            width: jiggerSize.width * 0.52,
            height: max(3, jiggerSize.height * 0.065 * fillRatio)
        )

        jiggerLiquidNode.path = CGPath(ellipseIn: liquidRect, transform: nil)
        let jiggerLiquidColor = ingredientColor(for: state.jiggerIngredientID ?? state.selectedIngredientID)
        jiggerLiquidNode.fillColor = jiggerLiquidColor.withAlphaComponent(0.58)
        jiggerLiquidNode.strokeColor = UIColor(white: 1, alpha: 0.26)
        jiggerLiquidNode.lineWidth = max(0.8, jiggerSize.width * 0.018)
        jiggerLiquidNode.zPosition = 4

        jiggerLiquidNode.isHidden = fillRatio <= 0
        if fillRatio <= 0 {
            jiggerFeedbackNode.removeAllActions()
            jiggerFeedbackNode.isHidden = true
        }

        let didChangeJiggerLiquid = lastRenderedJiggerAmount <= 0
            || lastRenderedJiggerIngredientID != state.jiggerIngredientID
        if animated, state.jiggerAmount > 0, didChangeJiggerLiquid {
            runJiggerFillFeedback(color: jiggerLiquidColor)
        }

        lastRenderedJiggerAmount = state.jiggerAmount
        lastRenderedJiggerIngredientID = state.jiggerIngredientID
    }

    private func renderGlass(_ state: MixingSceneState, animated: Bool) {
        let layout = MixingSceneLayout(size: size)
        let glassSize = layout.glassSize
        let fillRatio = CGFloat(min(max(state.glassFillRatio, 0), 1))
        let liquidRect = renderGlassLiquid(fillRatio: fillRatio, glassSize: glassSize)

        rebuildIce(count: state.iceCount, glassSize: glassSize)
        rebuildLime(isVisible: state.hasLime, glassSize: glassSize)
        rebuildMint(count: state.mintLeaves, glassSize: glassSize)
        rebuildBubbles(isVisible: state.hasSoda, glassSize: glassSize)

        if animated, hasRenderedOnce {
            if state.glassFillRatio > lastRenderedGlassFill + 0.0001 {
                runGlassLiquidSettle()
            }
            if state.iceCount > lastRenderedIceCount {
                runFallingIce(glassSize: glassSize, restingTopY: liquidRect.maxY)
            }
        }

        lastRenderedIceCount = state.iceCount
        lastRenderedGlassFill = state.glassFillRatio
    }

    @discardableResult
    private func renderGlassLiquid(fillRatio: CGFloat, glassSize: CGSize) -> CGRect {
        let liquidBottom = -glassSize.height * 0.44
        let liquidHeight = fillRatio <= 0 ? 0 : max(glassSize.height * 0.05, glassSize.height * 0.74 * fillRatio)
        let liquidRect = CGRect(
            x: -glassSize.width * 0.43,
            y: liquidBottom,
            width: glassSize.width * 0.86,
            height: liquidHeight
        )
        let isEmpty = fillRatio <= 0

        glassLiquidDepthNode.path = CGPath(
            roundedRect: liquidRect.insetBy(dx: glassSize.width * 0.025, dy: 0),
            cornerWidth: glassSize.width * 0.05,
            cornerHeight: glassSize.width * 0.05,
            transform: nil
        )
        glassLiquidDepthNode.fillColor = UIColor(red: 0.48, green: 0.78, blue: 0.40, alpha: 0.32)
        glassLiquidDepthNode.strokeColor = .clear
        glassLiquidDepthNode.isHidden = isEmpty

        glassLiquidNode.path = CGPath(
            roundedRect: liquidRect,
            cornerWidth: glassSize.width * 0.05,
            cornerHeight: glassSize.width * 0.05,
            transform: nil
        )
        glassLiquidNode.fillColor = UIColor(red: 0.78, green: 0.93, blue: 0.62, alpha: 0.48)
        glassLiquidNode.strokeColor = UIColor(red: 0.94, green: 1.0, blue: 0.82, alpha: 0.12)
        glassLiquidNode.lineWidth = max(0.8, glassSize.width * 0.008)
        glassLiquidNode.isHidden = isEmpty

        let surfaceRect = CGRect(
            x: liquidRect.minX + glassSize.width * 0.03,
            y: liquidRect.maxY - glassSize.height * 0.012,
            width: liquidRect.width - glassSize.width * 0.06,
            height: max(2, glassSize.height * 0.024)
        )
        glassSurfaceNode.path = CGPath(ellipseIn: surfaceRect, transform: nil)
        glassSurfaceNode.fillColor = UIColor(red: 0.90, green: 0.98, blue: 0.78, alpha: 0.58)
        glassSurfaceNode.strokeColor = UIColor(white: 1, alpha: 0.16)
        glassSurfaceNode.lineWidth = max(0.6, glassSize.width * 0.006)
        glassSurfaceNode.isHidden = isEmpty

        let highlightRect = CGRect(
            x: liquidRect.minX + glassSize.width * 0.12,
            y: liquidRect.maxY - glassSize.height * 0.055,
            width: liquidRect.width * 0.46,
            height: max(1.5, glassSize.height * 0.018)
        )
        glassLiquidHighlightNode.path = CGPath(ellipseIn: highlightRect, transform: nil)
        glassLiquidHighlightNode.fillColor = UIColor(white: 1, alpha: 0.18)
        glassLiquidHighlightNode.strokeColor = .clear
        glassLiquidHighlightNode.isHidden = isEmpty

        return liquidRect
    }

    /// 倒入后液面快速上抬再回落，给“内容增加了”的即时反馈。
    private func runGlassLiquidSettle() {
        glassLiquidNode.removeAction(forKey: "glass-settle")
        let settle = SKAction.sequence([
            SKAction.scaleY(to: 1.10, duration: 0.10),
            SKAction.scaleY(to: 0.97, duration: 0.10),
            SKAction.scaleY(to: 1.0, duration: 0.12)
        ])
        glassLiquidNode.run(settle, withKey: "glass-settle")
    }

    /// 加冰时一颗冰块从杯口上方落入并轻微回弹，再交由静态冰层接管。
    private func runFallingIce(glassSize: CGSize, restingTopY: CGFloat) {
        let cube = SKSpriteNode(imageNamed: "ice_cube")
        let cubeSize = glassSize.width * 0.31
        cube.size = CGSize(width: cubeSize, height: cubeSize)
        cube.alpha = 0.0
        cube.zRotation = CGFloat.random(in: -0.4...0.4)
        cube.zPosition = 6
        let startY = glassSize.height * 0.62
        let restY = max(restingTopY - cubeSize * 0.2, -glassSize.height * 0.30)
        cube.position = CGPoint(x: CGFloat.random(in: -0.12...0.12) * glassSize.width, y: startY)
        glassGroup.addChild(cube)

        let drop = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.95, duration: 0.06),
            SKAction.group([
                SKAction.moveTo(y: restY, duration: 0.24),
                SKAction.rotate(byAngle: CGFloat.random(in: -0.5...0.5), duration: 0.24)
            ]),
            SKAction.moveBy(x: 0, y: cubeSize * 0.10, duration: 0.06),
            SKAction.moveBy(x: 0, y: -cubeSize * 0.10, duration: 0.06),
            SKAction.fadeOut(withDuration: 0.10),
            SKAction.removeFromParent()
        ])
        drop.timingMode = .easeIn
        cube.run(drop)
    }

    private func renderStreams(_ state: MixingSceneState) {
        let layout = MixingSceneLayout(size: size)
        var hasActiveStream = false
        if state.isPouring, let ingredientID = state.pouringIngredientID {
            let color = ingredientColor(for: ingredientID)
            let usesJigger = ingredientUsesJigger(ingredientID)
            let start = usesJigger ? jiggerPourStart(layout: layout) : directPourStart(layout: layout)
            let end = usesJigger ? jiggerPourTarget(layout: layout) : layout.glassPourTarget
            pourStreamNode.path = streamPath(from: start, to: end)
            pourStreamNode.strokeColor = color.withAlphaComponent(0.55)
            pourStreamNode.lineWidth = usesJigger ? 6 : 5
            pourStreamNode.isHidden = false
            runStreamParticlesIfNeeded(key: "pour", from: start, to: end, color: color)
            runImpactRipple(at: end, color: color)
            hasActiveStream = true
        } else {
            pourStreamNode.isHidden = true
            streamParticleLayerNode.removeAction(forKey: "pour-stream-particles")
        }

        if state.isTransferringJigger {
            let color = ingredientColor(for: state.jiggerIngredientID ?? state.selectedIngredientID)
            transferStreamNode.path = streamPath(from: layout.pourStart, to: layout.glassPourTarget)
            transferStreamNode.strokeColor = color.withAlphaComponent(0.55)
            transferStreamNode.lineWidth = 6
            transferStreamNode.isHidden = false
            runStreamParticlesIfNeeded(
                key: "transfer",
                from: layout.pourStart,
                to: layout.glassPourTarget,
                color: color
            )
            runImpactRipple(at: layout.glassPourTarget, color: color)
            hasActiveStream = true
        } else {
            transferStreamNode.isHidden = true
            streamParticleLayerNode.removeAction(forKey: "transfer-stream-particles")
        }

        if !hasActiveStream {
            streamParticleLayerNode.removeAllActions()
            streamImpactNode.removeAllActions()
            streamImpactNode.isHidden = true
        }
    }

    private func jiggerPourStart(layout: MixingSceneLayout) -> CGPoint {
        CGPoint(
            x: layout.jiggerCenter.x - layout.jiggerSize.width * 0.10,
            y: layout.jiggerCenter.y + layout.jiggerSize.height * 0.62
        )
    }

    private func jiggerPourTarget(layout: MixingSceneLayout) -> CGPoint {
        CGPoint(
            x: layout.jiggerCenter.x,
            y: layout.jiggerCenter.y + layout.jiggerSize.height * 0.38
        )
    }

    private func directPourStart(layout: MixingSceneLayout) -> CGPoint {
        CGPoint(
            x: layout.glassCenter.x - layout.glassSize.width * 0.16,
            y: layout.glassCenter.y + layout.glassSize.height * 0.66
        )
    }

    private func renderTransferGuide(_ state: MixingSceneState) {
        let layout = MixingSceneLayout(size: size)
        guard !state.isTransferringJigger, state.jiggerAmount > 0 else {
            transferGuideNode.isHidden = true
            transferArrowNode.isHidden = true
            transferGuideNode.removeAction(forKey: "transfer-guide-pulse")
            transferArrowNode.removeAction(forKey: "transfer-arrow-pulse")
            return
        }

        transferGuideNode.path = streamPath(from: layout.pourStart, to: layout.glassPourTarget)
        transferGuideNode.strokeColor = UIColor(white: 1, alpha: 0.24)
        transferGuideNode.lineWidth = 2.2
        transferGuideNode.isHidden = false

        transferArrowNode.path = transferChevronPath(from: layout.pourStart, to: layout.glassPourTarget)
        transferArrowNode.strokeColor = UIColor(white: 1, alpha: 0.34)
        transferArrowNode.fillColor = .clear
        transferArrowNode.lineWidth = 1.6
        transferArrowNode.lineCap = .round
        transferArrowNode.isHidden = false

        runTransferGuidePulseIfNeeded()
    }

    private func runStreamParticlesIfNeeded(key: String, from start: CGPoint, to end: CGPoint, color: UIColor) {
        let actionKey = "\(key)-stream-particles"
        guard streamParticleLayerNode.action(forKey: actionKey) == nil else {
            return
        }

        let spawn = SKAction.run { [weak self] in
            self?.spawnStreamParticle(from: start, to: end, color: color)
        }
        let wait = SKAction.wait(forDuration: 0.055)
        let particleLoop = SKAction.repeatForever(SKAction.sequence([spawn, wait]))
        streamParticleLayerNode.run(particleLoop, withKey: actionKey)
    }

    private func spawnStreamParticle(from start: CGPoint, to end: CGPoint, color: UIColor) {
        let radius = CGFloat.random(in: 1.4...2.8)
        let particle = SKShapeNode(circleOfRadius: radius)
        particle.fillColor = color.withAlphaComponent(0.78)
        particle.strokeColor = UIColor(white: 1, alpha: 0.18)
        particle.lineWidth = 0.5
        particle.position = CGPoint(
            x: start.x + CGFloat.random(in: -2.5...2.5),
            y: start.y + CGFloat.random(in: -2.5...2.5)
        )
        particle.zPosition = 1
        streamParticleLayerNode.addChild(particle)

        let path = streamPath(from: particle.position, to: CGPoint(
            x: end.x + CGFloat.random(in: -4...4),
            y: end.y + CGFloat.random(in: -3...3)
        ))
        let travel = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 0.30)
        travel.timingMode = .easeIn
        particle.run(SKAction.sequence([
            SKAction.group([
                travel,
                SKAction.fadeAlpha(to: 0.18, duration: 0.30)
            ]),
            SKAction.removeFromParent()
        ]))
    }

    private func runImpactRipple(at point: CGPoint, color: UIColor) {
        guard streamImpactNode.action(forKey: "impact-ripple") == nil else {
            return
        }

        let rippleRect = CGRect(x: -8, y: -3, width: 16, height: 6)
        streamImpactNode.path = CGPath(ellipseIn: rippleRect, transform: nil)
        streamImpactNode.position = point
        streamImpactNode.fillColor = .clear
        streamImpactNode.strokeColor = color.withAlphaComponent(0.45)
        streamImpactNode.lineWidth = 1.2
        streamImpactNode.alpha = 0
        streamImpactNode.setScale(0.65)
        streamImpactNode.isHidden = false

        let ripple = SKAction.sequence([
            SKAction.group([
                SKAction.fadeAlpha(to: 0.72, duration: 0.08),
                SKAction.scale(to: 1.05, duration: 0.12)
            ]),
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.24),
                SKAction.scale(to: 1.45, duration: 0.24)
            ]),
            SKAction.hide()
        ])
        streamImpactNode.run(ripple, withKey: "impact-ripple")
    }

    private func runTransferGuidePulseIfNeeded() {
        if transferGuideNode.action(forKey: "transfer-guide-pulse") == nil {
            let pulse = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.45, duration: 0.42),
                SKAction.fadeAlpha(to: 1.0, duration: 0.42)
            ])
            transferGuideNode.run(SKAction.repeatForever(pulse), withKey: "transfer-guide-pulse")
        }

        if transferArrowNode.action(forKey: "transfer-arrow-pulse") == nil {
            let pulse = SKAction.sequence([
                SKAction.group([
                    SKAction.fadeAlpha(to: 0.55, duration: 0.42),
                    SKAction.scale(to: 1.08, duration: 0.42)
                ]),
                SKAction.group([
                    SKAction.fadeAlpha(to: 1.0, duration: 0.42),
                    SKAction.scale(to: 1.0, duration: 0.42)
                ])
            ])
            transferArrowNode.run(SKAction.repeatForever(pulse), withKey: "transfer-arrow-pulse")
        }
    }

    private func renderShake(_ state: MixingSceneState) {
        glassGroup.removeAction(forKey: "shake")
        guard state.isShaking else {
            glassGroup.zRotation = 0
            glassGroup.position = MixingSceneLayout(size: size).glassCenter
            return
        }

        let moveLeft = SKAction.moveBy(x: -7, y: 0, duration: 0.04)
        let moveRight = SKAction.moveBy(x: 14, y: 0, duration: 0.08)
        let moveBack = SKAction.moveBy(x: -7, y: 0, duration: 0.04)
        let rotateLeft = SKAction.rotate(toAngle: -0.08, duration: 0.04)
        let rotateRight = SKAction.rotate(toAngle: 0.08, duration: 0.08)
        let rotateBack = SKAction.rotate(toAngle: 0, duration: 0.04)
        let shake = SKAction.group([
            SKAction.sequence([moveLeft, moveRight, moveBack]),
            SKAction.sequence([rotateLeft, rotateRight, rotateBack])
        ])
        glassGroup.run(SKAction.repeat(shake, count: 4), withKey: "shake")
    }

    private func runJiggerFillFeedback(color: UIColor) {
        jiggerFeedbackNode.removeAllActions()
        jiggerGroup.removeAction(forKey: "jigger-fill")

        jiggerFeedbackNode.strokeColor = color.withAlphaComponent(0.82)
        jiggerFeedbackNode.fillColor = color.withAlphaComponent(0.08)
        jiggerFeedbackNode.alpha = 0.0
        jiggerFeedbackNode.setScale(0.94)
        jiggerFeedbackNode.isHidden = false

        let feedback = SKAction.sequence([
            SKAction.group([
                SKAction.fadeAlpha(to: 0.78, duration: 0.08),
                SKAction.scale(to: 1.04, duration: 0.12)
            ]),
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.34),
                SKAction.scale(to: 1.16, duration: 0.34)
            ]),
            SKAction.hide()
        ])
        jiggerFeedbackNode.run(feedback)

        let bounce = SKAction.sequence([
            SKAction.scale(to: 1.035, duration: 0.08),
            SKAction.scale(to: 0.99, duration: 0.08),
            SKAction.scale(to: 1.0, duration: 0.10)
        ])
        jiggerGroup.run(bounce, withKey: "jigger-fill")
    }

    private func rebuildIce(count: Int, glassSize: CGSize) {
        iceLayerNode.removeAllChildren()
        guard count > 0 else {
            return
        }

        let cubeSize = glassSize.width * 0.30
        for index in 0..<min(count, 8) {
            let node = SKSpriteNode(imageNamed: "ice_cube")
            node.size = CGSize(width: cubeSize, height: cubeSize)
            node.alpha = 0.92
            node.zRotation = CGFloat(index) * 0.31
            node.position = CGPoint(
                x: CGFloat((index % 3) - 1) * glassSize.width * 0.18,
                y: -glassSize.height * 0.36 + CGFloat(index / 3) * cubeSize * 0.66
            )
            iceLayerNode.addChild(node)
        }
        iceLayerNode.zPosition = 2
    }

    private func rebuildLime(isVisible: Bool, glassSize: CGSize) {
        limeLayerNode.removeAllChildren()
        guard isVisible else {
            return
        }

        let node = SKSpriteNode(imageNamed: "lime_slice")
        let sliceSize = glassSize.width * 0.33
        node.size = CGSize(width: sliceSize, height: sliceSize)
        node.alpha = 0.92
        node.zRotation = -0.42
        node.position = CGPoint(x: glassSize.width * 0.19, y: -glassSize.height * 0.07)
        limeLayerNode.addChild(node)
        limeLayerNode.zPosition = 3
    }

    private func rebuildMint(count: Int, glassSize: CGSize) {
        mintLayerNode.removeAllChildren()
        guard count > 0 else {
            return
        }

        let leafSize = glassSize.width * 0.24
        for index in 0..<min(count, 8) {
            let node = SKSpriteNode(imageNamed: "mint_leaf")
            node.size = CGSize(width: leafSize, height: leafSize)
            node.alpha = 0.88
            node.zRotation = CGFloat(index) * 0.47
            node.position = CGPoint(
                x: CGFloat((index % 4) - 2) * glassSize.width * 0.13,
                y: -glassSize.height * 0.30 + CGFloat(index / 4) * leafSize * 0.66
            )
            mintLayerNode.addChild(node)
        }
        mintLayerNode.zPosition = 3
    }

    private func rebuildBubbles(isVisible: Bool, glassSize: CGSize) {
        bubbleLayerNode.removeAllChildren()
        guard isVisible else {
            return
        }

        for index in 0..<10 {
            let bubble = SKShapeNode(circleOfRadius: max(1.2, glassSize.width * (index % 2 == 0 ? 0.022 : 0.016)))
            bubble.fillColor = UIColor(white: 1, alpha: 0.42)
            bubble.strokeColor = .clear
            bubble.position = CGPoint(
                x: CGFloat(index % 4 - 2) * glassSize.width * 0.12 + glassSize.width * 0.04,
                y: -glassSize.height * 0.38 + CGFloat(index) * glassSize.height * 0.052
            )
            bubbleLayerNode.addChild(bubble)
        }
        bubbleLayerNode.zPosition = 2
    }

    private func streamPath(from start: CGPoint, to end: CGPoint) -> CGPath {
        let path = CGMutablePath()
        path.move(to: start)
        path.addQuadCurve(
            to: end,
            control: CGPoint(x: (start.x + end.x) / 2, y: max(start.y, end.y) + 24)
        )
        return path
    }

    private func transferChevronPath(from start: CGPoint, to end: CGPoint) -> CGPath {
        let angle = atan2(end.y - start.y, end.x - start.x)
        let tip = CGPoint(
            x: start.x + (end.x - start.x) * 0.63,
            y: start.y + (end.y - start.y) * 0.63 + 6
        )
        let length: CGFloat = 10
        let wingAngle: CGFloat = 0.62
        let left = CGPoint(
            x: tip.x - cos(angle - wingAngle) * length,
            y: tip.y - sin(angle - wingAngle) * length
        )
        let right = CGPoint(
            x: tip.x - cos(angle + wingAngle) * length,
            y: tip.y - sin(angle + wingAngle) * length
        )

        let path = CGMutablePath()
        path.move(to: tip)
        path.addLine(to: left)
        path.move(to: tip)
        path.addLine(to: right)
        return path
    }

    private func ingredientUsesJigger(_ id: String) -> Bool {
        id == MojitoIngredient.whiteRum.id || id == MojitoIngredient.limeJuice.id || id == MojitoIngredient.syrup.id
    }

    private func ingredientColor(for id: String) -> UIColor {
        switch id {
        case MojitoIngredient.whiteRum.id:
            return UIColor(red: 0.85, green: 0.95, blue: 0.92, alpha: 1)
        case MojitoIngredient.limeJuice.id:
            return UIColor(red: 0.45, green: 0.90, blue: 0.38, alpha: 1)
        case MojitoIngredient.syrup.id:
            return UIColor(red: 0.96, green: 0.82, blue: 0.36, alpha: 1)
        case MojitoIngredient.soda.id:
            return UIColor(red: 0.62, green: 0.90, blue: 1.0, alpha: 1)
        case MojitoIngredient.mint.id:
            return UIColor(red: 0.18, green: 0.74, blue: 0.40, alpha: 1)
        default:
            return UIColor(white: 1, alpha: 1)
        }
    }
}
