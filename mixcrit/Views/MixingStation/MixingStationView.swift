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
    @State private var pourTickCount = 0
    @State private var lastJiggerMark: Double?
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
                    .padding(.top, layout.verticalPadding)

                mixingStage(layout: layout)
                    .frame(maxHeight: .infinity)
                    .padding(.top, layout.sectionSpacing)
                    .padding(.bottom, max(12, layout.sectionSpacing * 1.8))

                controlDock(layout: layout)
                    .frame(height: layout.controlDockHeight, alignment: .bottom)
                    .padding(.bottom, layout.verticalPadding)
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
        VStack(alignment: .leading, spacing: layout.isUltraCompact ? 2 : 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("订单")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.42))
                    Text("Mojito")
                        .font(.system(size: max(18, 28 * layout.scale), weight: .black, design: .rounded))
                        .lineLimit(1)
                }

                Spacer(minLength: 8)

                if layout.isUltraCompact {
                    Text("清爽·薄荷·少甜")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                } else {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("客人偏好")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white.opacity(0.58))
                        Text("清爽 / 薄荷香 / 不太甜")
                            .font((layout.isCompact ? Font.caption2 : Font.subheadline).weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .foregroundStyle(.white.opacity(0.84))
                    }
                }
            }

            Text(orderStatusText)
                .font(.caption2)
                .lineLimit(1)
                .minimumScaleFactor(0.70)
                .foregroundStyle(.white.opacity(0.62))
        }
        .padding(layout.isUltraCompact ? 8 : max(10, 14 * layout.scale))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, layout.horizontalPadding)
    }

    private func ingredientSelector(layout: ScreenLayout) -> some View {
        let itemSpacing = max(4, 6 * layout.scale)

        return HStack(spacing: itemSpacing) {
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
                .frame(maxWidth: .infinity)
                .frame(height: layout.ingredientRowHeight)
            }
        }
    }

    private func controlDock(layout: ScreenLayout) -> some View {
        let rowSpacing = layout.actionRowSpacing

        return VStack(spacing: rowSpacing) {
            ingredientSelector(layout: layout)

            HStack(spacing: max(6, 10 * layout.scale)) {
                ActionButton(title: "量杯入杯", systemImage: "arrow.down.to.line.compact", tint: Color(red: 0.90, green: 0.78, blue: 0.52), layout: layout) {
                    transferJiggerToGlass()
                }

                ActionButton(title: "加冰 \(currentMix.iceCount)/6", systemImage: "snowflake", tint: Color(red: 0.64, green: 0.88, blue: 1.0), layout: layout) {
                    addIce()
                }
            }

            HStack(spacing: max(6, 10 * layout.scale)) {
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
            }

            HStack(spacing: max(6, 10 * layout.scale)) {
                Button(role: .destructive) {
                    stopPouring()
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
                        jigger.empty()
                    }
                    hapticTick.toggle()
                } label: {
                    Label("清空量杯", systemImage: "xmark.circle.fill")
                        .font(.caption2.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .frame(maxWidth: .infinity)
                        .frame(height: layout.secondaryButtonHeight)
                }
                .buttonStyle(.bordered)
                .tint(.white.opacity(0.75))

                Button(role: .destructive, action: onReset) {
                    Label("重置这杯", systemImage: "arrow.counterclockwise")
                        .font(.caption2.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .frame(maxWidth: .infinity)
                        .frame(height: layout.secondaryButtonHeight)
                }
                .buttonStyle(.bordered)
                .tint(.white.opacity(0.75))
            }
        }
        .padding(.top, layout.dockTopPadding)
        .padding(.horizontal, layout.horizontalPadding)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.07, blue: 0.06).opacity(0.96),
                    Color(red: 0.04, green: 0.07, blue: 0.06)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
        )
    }

    private var pouringIngredient: MojitoIngredient? {
        guard let pouringIngredientID else {
            return nil
        }

        return ingredients.first { $0.id == pouringIngredientID }
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
            return "当前：\(selectedIngredient.name) · 量杯 \(active.name) \(Int(jigger.amount.rounded()))ml · 出杯自动计入"
        }

        return "当前：\(selectedIngredient.name) · 目标 \(Int(selectedIngredient.targetAmount))\(selectedIngredient.unit)"
    }

    private var instructionText: String {
        if selectedIngredient.usesJigger {
            if let active = jigger.activeIngredient, !jigger.isEmpty {
                return "量杯中：\(active.name) \(Int(jigger.amount.rounded()))ml · 到刻度会震动"
            }

            return "按住倒入量杯，看刻度控制用量；松手后点“量杯入杯”。"
        }

        return selectedIngredient == .mint ? "薄荷不走量杯，按住按片加入。" : "苏打水用于补满，直接倒入杯中。"
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
        guard !isPouring else {
            return
        }

        pourTask?.cancel()
        pourTickCount = 0
        lastJiggerMark = jigger.nearestMark
        isPouring = true
        pouringIngredientID = ingredient.id
        pourPulse.toggle()
        hapticTick.toggle()

        pourTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(145))

                await MainActor.run {
                    guard isPouring, pouringIngredientID == ingredient.id else {
                        return
                    }

                    withAnimation(.spring(response: 0.20, dampingFraction: 0.72)) {
                        if ingredient.usesJigger {
                            jigger.pour(ingredient)
                        } else {
                            currentMix.pour(ingredient)
                            glassMotionTick += 1
                        }
                        pourPulse.toggle()
                    }

                    pourTickCount += 1
                    if ingredient.usesJigger {
                        let newMark = jigger.nearestMark
                        if let newMark, newMark != lastJiggerMark, abs(jigger.amount - newMark) <= ingredient.pourAmount {
                            lastJiggerMark = newMark
                            hapticTick.toggle()
                        }
                    } else if pourTickCount.isMultiple(of: 4) {
                        hapticTick.toggle()
                    }
                }
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
        if jigger.snapToNearbyMark() {
            hapticTick.toggle()
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
