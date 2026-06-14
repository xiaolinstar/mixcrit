import SpriteKit
import UIKit

public final class MixingScene: SKScene {
    private var currentState: MixingSceneState?

    private let stageNode = SKShapeNode()
    private let glowNode = SKShapeNode()
    private let counterNode = SKShapeNode()
    private let counterEdgeNode = SKShapeNode()
    private let jiggerGroup = SKNode()
    private let jiggerBodyNode = SKShapeNode()
    private let jiggerImageNode = SKSpriteNode(imageNamed: "jigger_empty")
    private let jiggerLiquidNode = SKShapeNode()
    private let targetMarkNode = SKShapeNode()
    private let targetMarkLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
    private let glassGroup = SKNode()
    private let glassImageNode = SKSpriteNode(imageNamed: "highball_glass_empty")
    private let glassLiquidNode = SKShapeNode()
    private let glassRimNode = SKShapeNode()
    private let glassBaseNode = SKShapeNode()
    private let glassShineNode = SKShapeNode()
    private let iceLayerNode = SKNode()
    private let mintLayerNode = SKNode()
    private let bubbleLayerNode = SKNode()
    private let transferGuideNode = SKShapeNode()
    private let pourStreamNode = SKShapeNode()
    private let transferStreamNode = SKShapeNode()

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
        addChild(counterNode)
        addChild(counterEdgeNode)
        addChild(transferGuideNode)
        addChild(jiggerGroup)
        addChild(glassGroup)
        addChild(pourStreamNode)
        addChild(transferStreamNode)

        jiggerGroup.addChild(jiggerBodyNode)
        jiggerGroup.addChild(jiggerLiquidNode)
        jiggerGroup.addChild(jiggerImageNode)
        jiggerGroup.addChild(targetMarkNode)
        jiggerGroup.addChild(targetMarkLabel)

        glassGroup.addChild(glassLiquidNode)
        glassGroup.addChild(bubbleLayerNode)
        glassGroup.addChild(iceLayerNode)
        glassGroup.addChild(mintLayerNode)
        glassGroup.addChild(glassRimNode)
        glassGroup.addChild(glassBaseNode)
        glassGroup.addChild(glassShineNode)
        glassGroup.addChild(glassImageNode)

        stageNode.zPosition = 0
        glowNode.zPosition = 1
        counterNode.zPosition = 2
        counterEdgeNode.zPosition = 3
        transferGuideNode.zPosition = 3
        jiggerGroup.zPosition = 4
        glassGroup.zPosition = 4
        pourStreamNode.zPosition = 7
        transferStreamNode.zPosition = 7

        jiggerImageNode.alpha = 0.22
        glassImageNode.alpha = 0.92
        glassRimNode.lineWidth = 2
        glassBaseNode.lineWidth = 2
        glassShineNode.lineCap = .round
        transferGuideNode.lineCap = .round
        pourStreamNode.lineCap = .round
        transferStreamNode.lineCap = .round
    }

    private func layoutNodes() {
        let layout = MixingSceneLayout(size: size)
        let stageRect = layout.stageRect
        let counterRect = layout.counterRect

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
            y: stageRect.maxY - stageRect.height * 0.17,
            width: stageRect.width * 0.44,
            height: stageRect.height * 0.09
        ), transform: nil)
        glowNode.fillColor = UIColor(red: 0.95, green: 0.66, blue: 0.26, alpha: 0.055)
        glowNode.strokeColor = .clear

        counterNode.path = CGPath(
            roundedRect: counterRect,
            cornerWidth: 16,
            cornerHeight: 16,
            transform: nil
        )
        counterNode.fillColor = UIColor(red: 0.19, green: 0.12, blue: 0.08, alpha: 0.94)
        counterNode.strokeColor = UIColor(red: 0.85, green: 0.58, blue: 0.30, alpha: 0.16)
        counterNode.lineWidth = 1

        let edgeRect = CGRect(
            x: counterRect.minX,
            y: counterRect.maxY - counterRect.height * 0.18,
            width: counterRect.width,
            height: counterRect.height * 0.18
        )
        counterEdgeNode.path = CGPath(
            roundedRect: edgeRect,
            cornerWidth: 12,
            cornerHeight: 12,
            transform: nil
        )
        counterEdgeNode.fillColor = UIColor(red: 0.78, green: 0.48, blue: 0.22, alpha: 0.26)
        counterEdgeNode.strokeColor = .clear

        jiggerGroup.position = layout.jiggerCenter
        glassGroup.position = layout.glassCenter
        layoutJigger(size: layout.jiggerSize)
        layoutGlass(size: layout.glassSize)
    }

    private func layoutJigger(size: CGSize) {
        let bodyRect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
        jiggerBodyNode.path = CGPath(
            roundedRect: bodyRect,
            cornerWidth: size.width * 0.20,
            cornerHeight: size.width * 0.20,
            transform: nil
        )
        jiggerBodyNode.fillColor = UIColor(white: 1, alpha: 0.055)
        jiggerBodyNode.strokeColor = UIColor(white: 1, alpha: 0.50)
        jiggerBodyNode.lineWidth = 2

        jiggerImageNode.size = CGSize(width: size.width * 1.20, height: size.height * 0.64)
        jiggerImageNode.position = CGPoint(x: 0, y: -size.height * 0.05)
        jiggerImageNode.zPosition = 3

        targetMarkLabel.fontSize = max(11, size.width * 0.18)
        targetMarkLabel.horizontalAlignmentMode = .right
        targetMarkLabel.verticalAlignmentMode = .center
    }

    private func layoutGlass(size: CGSize) {
        glassImageNode.size = CGSize(width: size.width * 1.65, height: size.height)
        glassImageNode.position = .zero
        glassImageNode.zPosition = 4

        let rimRect = CGRect(
            x: -size.width * 0.39,
            y: size.height * 0.31,
            width: size.width * 0.78,
            height: size.height * 0.09
        )
        glassRimNode.path = CGPath(ellipseIn: rimRect, transform: nil)
        glassRimNode.strokeColor = UIColor(white: 1, alpha: 0.38)
        glassRimNode.fillColor = UIColor(white: 1, alpha: 0.035)
        glassRimNode.zPosition = 5

        let baseRect = CGRect(
            x: -size.width * 0.34,
            y: -size.height * 0.43,
            width: size.width * 0.68,
            height: size.height * 0.10
        )
        glassBaseNode.path = CGPath(ellipseIn: baseRect, transform: nil)
        glassBaseNode.strokeColor = UIColor(white: 1, alpha: 0.22)
        glassBaseNode.fillColor = UIColor(white: 1, alpha: 0.05)
        glassBaseNode.zPosition = 5

        let shinePath = CGMutablePath()
        shinePath.move(to: CGPoint(x: -size.width * 0.24, y: size.height * 0.22))
        shinePath.addLine(to: CGPoint(x: -size.width * 0.20, y: -size.height * 0.22))
        glassShineNode.path = shinePath
        glassShineNode.strokeColor = UIColor(white: 1, alpha: 0.22)
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
        let liquidHeight = max(2, jiggerSize.height * 0.78 * fillRatio)
        let liquidRect = CGRect(
            x: -jiggerSize.width * 0.34,
            y: -jiggerSize.height * 0.42,
            width: jiggerSize.width * 0.68,
            height: liquidHeight
        )

        jiggerLiquidNode.path = CGPath(
            roundedRect: liquidRect,
            cornerWidth: jiggerSize.width * 0.10,
            cornerHeight: jiggerSize.width * 0.10,
            transform: nil
        )
        jiggerLiquidNode.fillColor = ingredientColor(for: state.jiggerIngredientID ?? state.selectedIngredientID).withAlphaComponent(0.68)
        jiggerLiquidNode.strokeColor = .clear
        jiggerLiquidNode.zPosition = 2

        if state.selectedIngredientUsesJigger {
            let targetRatio = CGFloat(min(max(state.selectedIngredientTargetAmount / max(state.jiggerCapacity, 1), 0), 1))
            let y = -jiggerSize.height * 0.42 + jiggerSize.height * 0.78 * targetRatio
            let markPath = CGMutablePath()
            markPath.move(to: CGPoint(x: -jiggerSize.width * 0.10, y: y))
            markPath.addLine(to: CGPoint(x: jiggerSize.width * 0.42, y: y))
            targetMarkNode.path = markPath
            targetMarkNode.strokeColor = UIColor(red: 0.98, green: 0.78, blue: 0.20, alpha: 1)
            targetMarkNode.lineWidth = 2
            targetMarkNode.isHidden = false

            targetMarkLabel.text = "\(Int(state.selectedIngredientTargetAmount))"
            targetMarkLabel.position = CGPoint(x: -jiggerSize.width * 0.18, y: y)
            targetMarkLabel.fontColor = targetMarkNode.strokeColor
            targetMarkLabel.isHidden = false
        } else {
            targetMarkNode.isHidden = true
            targetMarkLabel.isHidden = true
        }
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
            pourStreamNode.lineWidth = 5
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
        guard state.jiggerAmount > 0, !state.isTransferringJigger else {
            transferGuideNode.isHidden = true
            return
        }

        let layout = MixingSceneLayout(size: size)
        transferGuideNode.path = streamPath(from: layout.pourStart, to: layout.glassPourTarget)
        transferGuideNode.strokeColor = UIColor(white: 1, alpha: 0.16)
        transferGuideNode.lineWidth = 2
        transferGuideNode.isHidden = false
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

    private func rebuildIce(count: Int, glassSize: CGSize) {
        iceLayerNode.removeAllChildren()
        guard count > 0 else {
            return
        }

        let cubeSize = glassSize.width * 0.20
        for index in 0..<min(count, 8) {
            let node = SKSpriteNode(imageNamed: "ice_cube")
            node.size = CGSize(width: cubeSize, height: cubeSize)
            node.alpha = 0.78
            node.zRotation = CGFloat(index) * 0.31
            node.position = CGPoint(
                x: CGFloat((index % 3) - 1) * glassSize.width * 0.18,
                y: -glassSize.height * 0.24 + CGFloat(index / 3) * cubeSize * 0.76
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
