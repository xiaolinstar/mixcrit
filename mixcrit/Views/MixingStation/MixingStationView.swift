import SwiftUI

public struct MixingStationView: View {
    @Binding var selectedIngredientID: String
    @Binding var currentMix: MojitoMix
    @Binding var jigger: JiggerState
    @Binding var isShaking: Bool
    @Binding var isPouring: Bool
    @Binding var pouringIngredientID: String?
    @Binding var isTransferringJigger: Bool
    @Binding var hapticTick: Bool

    @State private var pourTask: Task<Void, Never>?
    @State private var pourPulse = false
    @State private var glassMotionTick = 0
    @State private var fallingIceTick = 0
    @State private var isFallingIceVisible = false

    let ingredients: [MojitoIngredient]
    let onServe: () -> Void
    let onReset: () -> Void

    public init(
        selectedIngredientID: Binding<String>,
        currentMix: Binding<MojitoMix>,
        jigger: Binding<JiggerState>,
        isShaking: Binding<Bool>,
        isPouring: Binding<Bool>,
        pouringIngredientID: Binding<String?>,
        isTransferringJigger: Binding<Bool>,
        hapticTick: Binding<Bool>,
        ingredients: [MojitoIngredient],
        onServe: @escaping () -> Void,
        onReset: @escaping () -> Void
    ) {
        self._selectedIngredientID = selectedIngredientID
        self._currentMix = currentMix
        self._jigger = jigger
        self._isShaking = isShaking
        self._isPouring = isPouring
        self._pouringIngredientID = pouringIngredientID
        self._isTransferringJigger = isTransferringJigger
        self._hapticTick = hapticTick
        self.ingredients = ingredients
        self.onServe = onServe
        self.onReset = onReset
    }

    private var selectedIngredient: MojitoIngredient {
        ingredients.first { $0.id == selectedIngredientID } ?? .whiteRum
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = ScreenLayout(size: proxy.size, safeArea: proxy.safeAreaInsets)

            VStack(spacing: 0) {
                orderCard(layout: layout)
                    .frame(height: layout.orderCardHeight, alignment: .top)
                    .padding(.top, max(4, layout.verticalPadding))

                mixingStage(layout: layout)
                    .frame(maxHeight: .infinity)
                    .padding(.top, max(2, layout.sectionSpacing * 0.8))
                    .padding(.bottom, max(5, layout.sectionSpacing))

                controlDock(layout: layout)
                    .frame(height: layout.controlDockHeight, alignment: .bottom)
                    .padding(.bottom, max(0, layout.verticalPadding - 4))
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
        }
        .onDisappear {
            stopPouring()
            isTransferringJigger = false
        }
    }

    private func mixingStage(layout: ScreenLayout) -> some View {
        MixingSceneContainerView(state: mixingSceneState)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, layout.horizontalPadding)
    }

    private func orderCard(layout: ScreenLayout) -> some View {
        HStack(spacing: max(7, 10 * layout.scale)) {
            HStack(spacing: 6) {
                Image(systemName: "list.clipboard.fill")
                    .font(.system(size: max(13, 16 * layout.scale), weight: .bold))
                    .foregroundStyle(Color(red: 0.95, green: 0.78, blue: 0.42))
                Text("订单 Mojito")
                    .font(.system(size: max(13, 16 * layout.scale), weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }

            Divider()
                .frame(height: max(18, 24 * layout.scale))
                .overlay(.white.opacity(0.18))

            HStack(spacing: 6) {
                Image(selectedIngredient.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: max(17, 23 * layout.scale), height: max(22, 28 * layout.scale))
                Text("\(selectedIngredient.name) \(Int(currentMix.amount(for: selectedIngredient))) / \(Int(selectedIngredient.targetAmount))\(selectedIngredient.unit)")
                    .font(.system(size: max(11, 14 * layout.scale), weight: .bold, design: .rounded))
                    .foregroundStyle(selectedIngredient.tint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.52)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: max(18, 24 * layout.scale))
                .overlay(.white.opacity(0.18))

            HStack(spacing: 1) {
                ForEach(0..<3, id: \.self) { _ in
                    Image(systemName: "star")
                        .font(.system(size: max(12, 16 * layout.scale), weight: .semibold))
                }
            }
            .foregroundStyle(Color(red: 0.95, green: 0.70, blue: 0.28).opacity(0.78))
            .lineLimit(1)
            .minimumScaleFactor(0.68)
        }
        .padding(.horizontal, max(10, 13 * layout.scale))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .background(.ultraThinMaterial, in: Capsule())
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.12),
                    Color(red: 0.95, green: 0.76, blue: 0.42).opacity(0.07),
                    Color.black.opacity(0.20)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: Capsule()
        )
        .overlay {
            Capsule()
                .stroke(.white.opacity(0.24), lineWidth: 1)
        }
        .overlay(alignment: .topLeading) {
            Capsule()
                .stroke(.white.opacity(0.18), lineWidth: 0.6)
                .blur(radius: 0.2)
                .blendMode(.plusLighter)
        }
        .shadow(color: .black.opacity(0.20), radius: 14, y: 8)
        .padding(.horizontal, layout.horizontalPadding)
    }

    private func ingredientSelector(layout: ScreenLayout) -> some View {
        HStack(spacing: layout.ingredientItemSpacing) {
            ForEach(ingredients) { ingredient in
                BarIngredientObjectView(
                    ingredient: ingredient,
                    amount: currentMix.amount(for: ingredient),
                    isSelected: selectedIngredientID == ingredient.id,
                    isActive: isPouring && pouringIngredientID == ingredient.id,
                    layout: layout,
                    onSelect: {
                        selectedIngredientID = ingredient.id
                    },
                    onStart: {
                        selectedIngredientID = ingredient.id
                        startPouring(ingredient)
                    },
                    onStop: stopPouring
                )
                .frame(width: layout.ingredientItemWidth, height: layout.ingredientRowHeight)
            }
        }
    }

    private func controlDock(layout: ScreenLayout) -> some View {
        VStack(spacing: layout.actionRowSpacing) {
            ingredientSelector(layout: layout)

            HStack(spacing: max(5, 7 * layout.scale)) {
                ActionButton(title: "量杯入杯", systemImage: "arrow.down.to.line.compact", tint: Color(red: 0.90, green: 0.78, blue: 0.52), layout: layout) {
                    transferJiggerToGlass()
                }

                ActionButton(title: "加冰 \(currentMix.iceCount)/6", systemImage: "snowflake", tint: Color(red: 0.64, green: 0.88, blue: 1.0), layout: layout) {
                    addIce()
                }

                ActionButton(title: "摇酒 \(currentMix.shakeCount)/3", systemImage: "hands.sparkles.fill", tint: Color(red: 0.95, green: 0.76, blue: 0.32), layout: layout) {
                    stopPouring()
                    currentMix.shake()
                    glassMotionTick += 1
                    hapticTick.toggle()
                    withAnimation(.linear(duration: 0.08).repeatCount(6, autoreverses: true)) {
                        isShaking = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        isShaking = false
                    }
                }

                ActionButton(title: "出杯", systemImage: "checkmark.seal.fill", tint: Color(red: 0.26, green: 0.78, blue: 0.46), layout: layout) {
                    finalizeAndServe()
                }

                ActionButton(title: "清空量杯", systemImage: "xmark.circle.fill", tint: Color(white: 0.78), layout: layout) {
                    clearJigger()
                }
            }
        }
        .padding(.top, layout.dockTopPadding)
        .padding(.horizontal, layout.horizontalPadding)
        .padding(.bottom, max(2, layout.verticalPadding))
        .background(alignment: .bottom) {
            UnevenRoundedRectangle(topLeadingRadius: 18, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
                .overlay {
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color(red: 0.10, green: 0.12, blue: 0.10).opacity(0.62),
                            Color.black.opacity(0.36)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 18, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 18, style: .continuous))
                    .ignoresSafeArea(edges: .bottom)
                }
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.white.opacity(0.20))
                        .frame(height: 1)
                }
                .shadow(color: .black.opacity(0.28), radius: 18, y: -6)
        }
    }

    private var mixingSceneState: MixingSceneState {
        MixingSceneState(
            selectedIngredientID: selectedIngredient.id,
            selectedIngredientUsesJigger: selectedIngredient.usesJigger,
            selectedIngredientTargetAmount: selectedIngredient.targetAmount,
            jiggerIngredientID: jigger.ingredientID,
            jiggerAmount: jigger.amount,
            jiggerCapacity: jigger.capacity,
            glassFillRatio: currentMix.fillRatio,
            iceCount: currentMix.iceCount,
            mintLeaves: currentMix.mintLeaves,
            hasLime: currentMix.amount(for: .limeJuice) > 0,
            hasSoda: currentMix.amount(for: .soda) > 0,
            isPouring: isPouring,
            pouringIngredientID: pouringIngredientID,
            isTransferringJigger: isTransferringJigger,
            isShaking: isShaking
        )
    }

    private var orderStatusText: String {
        if let active = jigger.activeIngredient, jigger.amount > 0 {
            return "量杯：\(active.name) \(Int(jigger.amount.rounded()))ml · 点“量杯入杯”"
        }

        if selectedIngredient.usesJigger {
            return "\(selectedIngredient.name)：点击装入 15ml 量杯 · 目标 \(Int(selectedIngredient.targetAmount))\(selectedIngredient.unit)"
        }

        return "\(selectedIngredient.name)：点击加入 \(Int(selectedIngredient.stepAmount))\(selectedIngredient.unit) · 目标 \(Int(selectedIngredient.targetAmount))\(selectedIngredient.unit)"
    }

    private var instructionText: String {
        if selectedIngredient.usesJigger {
            if let active = jigger.activeIngredient, !jigger.isEmpty {
                return "量杯中：\(active.name) \(Int(jigger.amount.rounded()))ml · 点“量杯入杯”加入成品杯"
            }

            return "点击原料装入 15ml 量杯，再点“量杯入杯”。"
        }

        return selectedIngredient == .mint ? "点击一次加入 2 片薄荷。" : "点击一次加入 30ml 苏打水。"
    }

    private func addIce() {
        stopPouring()
        withAnimation(.spring(response: 0.28, dampingFraction: 0.66)) {
            currentMix.addIce()
            glassMotionTick += 1
            fallingIceTick += 1
            isFallingIceVisible = true
        }
        hapticTick.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) {
            withAnimation(.easeOut(duration: 0.16)) {
                isFallingIceVisible = false
            }
        }
    }

    private func startPouring(_ ingredient: MojitoIngredient) {
        pourTask?.cancel()
        isPouring = true
        pouringIngredientID = ingredient.id
        pourPulse.toggle()

        withAnimation(.spring(response: 0.22, dampingFraction: 0.72)) {
            if ingredient.usesJigger {
                guard jigger.isEmpty || jigger.ingredientID == ingredient.id else {
                    hapticTick.toggle()
                    return
                }

                jigger.fillUnit(with: ingredient)
            } else {
                currentMix.add(ingredient)
                glassMotionTick += 1
            }
            pourPulse.toggle()
        }
        hapticTick.toggle()

        DispatchQueue.main.asyncAfter(deadline: .now() + (ingredient.usesJigger ? 0.46 : 0.26)) {
            if pouringIngredientID == ingredient.id {
                isPouring = false
                pouringIngredientID = nil
            }
        }
    }

    private func stopPouring() {
        guard isPouring || pourTask != nil else {
            return
        }

        pourTask?.cancel()
        pourTask = nil
        isPouring = false
        pouringIngredientID = nil
        hapticTick.toggle()
    }

    private func clearJigger() {
        stopPouring()
        withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
            jigger.empty()
        }
        hapticTick.toggle()
    }

    private func transferJiggerToGlass() {
        stopPouring()

        guard let ingredient = jigger.activeIngredient, jigger.amount > 0 else {
            hapticTick.toggle()
            return
        }

        withAnimation(.spring(response: 0.34, dampingFraction: 0.74)) {
            isTransferringJigger = true
            currentMix.add(ingredient, amount: jigger.amount)
            glassMotionTick += 1
        }
        hapticTick.toggle()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.80)) {
                jigger.empty()
                isTransferringJigger = false
            }
        }
    }

    private func finalizeAndServe() {
        stopPouring()
        if let ingredient = jigger.activeIngredient, jigger.amount > 0 {
            currentMix.add(ingredient, amount: jigger.amount)
            glassMotionTick += 1
            jigger.empty()
            isTransferringJigger = false
        }
        onServe()
    }
}
