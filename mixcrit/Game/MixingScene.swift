import SpriteKit
import UIKit

public final class MixingScene: SKScene {
    private var currentState: MixingSceneState?

    private let stageNode = SKShapeNode()
    private let glowNode = SKShapeNode()
    private let transferArrowNode = SKShapeNode()
    private let jiggerGroup = SKNode()
    private let jiggerFeedbackNode = SKShapeNode()
    private let jiggerImageNode = SKSpriteNode(imageNamed: "jigger_empty")
    private let jiggerLiquidNode = SKShapeNode()
    private let glassGroup = SKNode()
    private let glassImageNode = SKSpriteNode(imageNamed: "highball_glass_empty")
    private let glassLiquidNode = SKShapeNode()
    private let glassShineNode = SKShapeNode()
    private let iceLayerNode = SKNode()
    private let mintLayerNode = SKNode()
    private let bubbleLayerNode = SKNode()
    private let transferGuideNode = SKShapeNode()
    private let pourStreamNode = SKShapeNode()
    private let transferStreamNode = SKShapeNode()
    private var lastRenderedJiggerAmount: Double = 0
    private var lastRenderedJiggerIngredientID: String?

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
        addChild(glowNode)
        addChild(transferGuideNode)
        addChild(transferArrowNode)
        addChild(jiggerGroup)
        addChild(glassGroup)
        addChild(pourStreamNode)
        addChild(transferStreamNode)

        jiggerGroup.addChild(jiggerFeedbackNode)
        jiggerGroup.addChild(jiggerLiquidNode)
        jiggerGroup.addChild(jiggerImageNode)

        glassGroup.addChild(glassLiquidNode)
        glassGroup.addChild(bubbleLayerNode)
        glassGroup.addChild(iceLayerNode)
        glassGroup.addChild(mintLayerNode)
        glassGroup.addChild(glassShineNode)
        glassGroup.addChild(glassImageNode)

        stageNode.zPosition = 0
        glowNode.zPosition = 1
        transferGuideNode.zPosition = 3
        transferArrowNode.zPosition = 3
        jiggerGroup.zPosition = 4
        glassGroup.zPosition = 4
        pourStreamNode.zPosition = 7
        transferStreamNode.zPosition = 7

        jiggerImageNode.alpha = 0.92
        jiggerFeedbackNode.isHidden = true
        glassImageNode.alpha = 0.96
        glassShineNode.lineCap = .round
        transferGuideNode.lineCap = .round
        pourStreamNode.lineCap = .round
        transferStreamNode.lineCap = .round
    }

    private func layoutNodes() {
        let layout = MixingSceneLayout(size: size)
        let stageRect = layout.stageRect

        stageNode.path = CGPath(
            roundedRect: stageRect,
            cornerWidth: max(20, stageRect.width * 0.055),
            cornerHeight: max(20, stageRect.width * 0.055),
            transform: nil
        )
        stageNode.fillColor = UIColor(red: 0.08, green: 0.09, blue: 0.08, alpha: 0.96)
        stageNode.strokeColor = UIColor(white: 1, alpha: 0.10)
        stageNode.lineWidth = 1

        glowNode.path = CGPath(ellipseIn: CGRect(
            x: stageRect.midX - stageRect.width * 0.22,
            y: stageRect.maxY - stageRect.height * 0.20,
            width: stageRect.width * 0.44,
            height: stageRect.height * 0.09
        ), transform: nil)
        glowNode.fillColor = UIColor(white: 1, alpha: 0.035)
        glowNode.strokeColor = .clear

        jiggerGroup.position = layout.jiggerCenter
        glassGroup.position = layout.glassCenter
        layoutJigger(size: layout.jiggerSize)
        layoutGlass(size: layout.glassSize)
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
        glassImageNode.size = CGSize(width: size.width * 1.78, height: size.height * 1.08)
        glassImageNode.position = .zero
        glassImageNode.zPosition = 4

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
        jiggerLiquidNode.fillColor = ingredientColor(for: state.jiggerIngredientID ?? state.selectedIngredientID).withAlphaComponent(0.58)
        jiggerLiquidNode.strokeColor = UIColor(white: 1, alpha: 0.26)
        jiggerLiquidNode.lineWidth = max(0.8, jiggerSize.width * 0.018)
        jiggerLiquidNode.zPosition = 4

        jiggerLiquidNode.isHidden = fillRatio <= 0
        if fillRatio <= 0 {
            jiggerFeedbackNode.removeAllActions()
            jiggerFeedbackNode.isHidden = true
        }

        if animated,
           state.jiggerAmount > 0,
           (lastRenderedJiggerAmount <= 0 || lastRenderedJiggerIngredientID != state.jiggerIngredientID) {
            runJiggerFillFeedback(color: ingredientColor(for: state.jiggerIngredientID ?? state.selectedIngredientID))
        }

        lastRenderedJiggerAmount = state.jiggerAmount
        lastRenderedJiggerIngredientID = state.jiggerIngredientID
    }

    private func renderGlass(_ state: MixingSceneState, animated: Bool) {
        let layout = MixingSceneLayout(size: size)
        let glassSize = layout.glassSize
        let fillRatio = CGFloat(min(max(state.glassFillRatio, 0), 1))
        let liquidHeight = max(2, glassSize.height * 0.60 * fillRatio)
        let liquidRect = CGRect(
            x: -glassSize.width * 0.32,
            y: -glassSize.height * 0.40,
            width: glassSize.width * 0.64,
            height: liquidHeight
        )

        glassLiquidNode.path = CGPath(
            roundedRect: liquidRect,
            cornerWidth: glassSize.width * 0.08,
            cornerHeight: glassSize.width * 0.08,
            transform: nil
        )
        glassLiquidNode.fillColor = UIColor(red: 0.68, green: 0.90, blue: 0.72, alpha: 0.44)
        glassLiquidNode.strokeColor = .clear
        glassLiquidNode.zPosition = 1

        rebuildIce(count: state.iceCount, glassSize: glassSize)
        rebuildMint(count: state.mintLeaves, glassSize: glassSize)
        rebuildBubbles(isVisible: state.hasSoda, glassSize: glassSize)
    }

    private func renderStreams(_ state: MixingSceneState) {
        let layout = MixingSceneLayout(size: size)
        if state.isPouring, let ingredientID = state.pouringIngredientID {
            let start = ingredientUsesJigger(ingredientID)
                ? CGPoint(x: layout.jiggerCenter.x - layout.jiggerSize.width * 0.10, y: layout.jiggerCenter.y + layout.jiggerSize.height * 0.62)
                : CGPoint(x: layout.glassCenter.x - layout.glassSize.width * 0.16, y: layout.glassCenter.y + layout.glassSize.height * 0.66)
            let end = ingredientUsesJigger(ingredientID) ? CGPoint(x: layout.jiggerCenter.x, y: layout.jiggerCenter.y + layout.jiggerSize.height * 0.38) : layout.glassPourTarget
            pourStreamNode.path = streamPath(from: start, to: end)
            pourStreamNode.strokeColor = ingredientColor(for: ingredientID).withAlphaComponent(0.82)
            pourStreamNode.lineWidth = ingredientUsesJigger(ingredientID) ? 6 : 5
            pourStreamNode.isHidden = false
        } else {
            pourStreamNode.isHidden = true
        }

        if state.isTransferringJigger {
            transferStreamNode.path = streamPath(from: layout.pourStart, to: layout.glassPourTarget)
            transferStreamNode.strokeColor = ingredientColor(for: state.jiggerIngredientID ?? state.selectedIngredientID).withAlphaComponent(0.82)
            transferStreamNode.lineWidth = 6
            transferStreamNode.isHidden = false
        } else {
            transferStreamNode.isHidden = true
        }
    }

    private func renderTransferGuide(_ state: MixingSceneState) {
        let layout = MixingSceneLayout(size: size)
        guard !state.isTransferringJigger else {
            transferGuideNode.isHidden = true
            transferArrowNode.isHidden = true
            return
        }

        transferGuideNode.path = streamPath(from: layout.pourStart, to: layout.glassPourTarget)
        transferGuideNode.strokeColor = UIColor(white: 1, alpha: state.jiggerAmount > 0 ? 0.24 : 0.12)
        transferGuideNode.lineWidth = state.jiggerAmount > 0 ? 2.2 : 1.5
        transferGuideNode.isHidden = false

        transferArrowNode.path = transferChevronPath(from: layout.pourStart, to: layout.glassPourTarget)
        transferArrowNode.strokeColor = UIColor(white: 1, alpha: state.jiggerAmount > 0 ? 0.34 : 0.18)
        transferArrowNode.fillColor = .clear
        transferArrowNode.lineWidth = 1.6
        transferArrowNode.lineCap = .round
        transferArrowNode.isHidden = false
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

        let cubeSize = glassSize.width * 0.28
        for index in 0..<min(count, 8) {
            let node = SKSpriteNode(imageNamed: "ice_cube")
            node.size = CGSize(width: cubeSize, height: cubeSize)
            node.alpha = 0.92
            node.zRotation = CGFloat(index) * 0.31
            node.position = CGPoint(
                x: CGFloat((index % 3) - 1) * glassSize.width * 0.16,
                y: -glassSize.height * 0.23 + CGFloat(index / 3) * cubeSize * 0.68
            )
            iceLayerNode.addChild(node)
        }
        iceLayerNode.zPosition = 2
    }

    private func rebuildMint(count: Int, glassSize: CGSize) {
        mintLayerNode.removeAllChildren()
        guard count > 0 else {
            return
        }

        let leafSize = glassSize.width * 0.22
        for index in 0..<min(count, 8) {
            let node = SKSpriteNode(imageNamed: "mint_leaf")
            node.size = CGSize(width: leafSize, height: leafSize)
            node.alpha = 0.88
            node.zRotation = CGFloat(index) * 0.47
            node.position = CGPoint(
                x: CGFloat((index % 4) - 2) * glassSize.width * 0.12,
                y: -glassSize.height * 0.20 + CGFloat(index / 4) * leafSize * 0.70
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

        for index in 0..<7 {
            let bubble = SKShapeNode(circleOfRadius: max(1.5, glassSize.width * 0.025))
            bubble.fillColor = UIColor(white: 1, alpha: 0.44)
            bubble.strokeColor = .clear
            bubble.position = CGPoint(
                x: CGFloat(index % 3 - 1) * glassSize.width * 0.13,
                y: -glassSize.height * 0.24 + CGFloat(index) * glassSize.height * 0.055
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
