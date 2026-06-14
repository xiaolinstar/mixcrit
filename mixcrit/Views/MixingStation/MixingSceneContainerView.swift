import SpriteKit
import SwiftUI

public struct MixingSceneContainerView: View {
    public let state: MixingSceneState
    @State private var scene = MixingScene(size: CGSize(width: 390, height: 460))

    public init(state: MixingSceneState) {
        self.state = state
    }

    public var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .onAppear {
                scene.update(with: state)
            }
            .onChange(of: state) { _, newState in
                scene.update(with: newState)
            }
    }
}
