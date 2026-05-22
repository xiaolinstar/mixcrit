//
//  ContentView.swift
//  mixcrit
//
//  Created by Xing Xiaolin on 2026/5/7.
//

import SwiftUI

struct ContentView: View {
    @State private var phase: GamePhase = .bar
    @State private var selectedIngredientID = MojitoIngredient.whiteRum.id
    @State private var currentMix = MojitoMix()
    @State private var jigger = JiggerState()
    @State private var lastScore: MojitoScore?
    @State private var isShaking = false
    @State private var isPouring = false
    @State private var pouringIngredientID: String?
    @State private var isTransferringJigger = false
    @State private var hapticTick = false

    private let ingredients = MojitoIngredient.allCases

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.07, blue: 0.08),
                    Color(red: 0.13, green: 0.09, blue: 0.07),
                    Color(red: 0.04, green: 0.08, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            switch phase {
            case .bar:
                BarHomeView {
                    phase = .mixing
                }
            case .mixing:
                MixingStationView(
                    selectedIngredientID: $selectedIngredientID,
                    currentMix: $currentMix,
                    jigger: $jigger,
                    isShaking: $isShaking,
                    isPouring: $isPouring,
                    pouringIngredientID: $pouringIngredientID,
                    isTransferringJigger: $isTransferringJigger,
                    hapticTick: $hapticTick,
                    ingredients: ingredients,
                    onServe: serveDrink,
                    onReset: { resetDrink(to: .mixing) }
                )
            case .score:
                ScoreView(
                    mix: currentMix,
                    score: lastScore ?? MojitoScore.empty,
                    onRetry: { resetDrink(to: .mixing) },
                    onBackToBar: {
                        resetDrink(to: .bar)
                    }
                )
            }
        }
        .preferredColorScheme(.dark)
        .sensoryFeedback(.impact(weight: .light, intensity: 0.65), trigger: hapticTick)
    }

    private func serveDrink() {
        lastScore = MojitoScorer.score(currentMix)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
            phase = .score
        }
    }

    private func resetDrink(to targetPhase: GamePhase) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
            currentMix = MojitoMix()
            jigger = JiggerState()
            selectedIngredientID = MojitoIngredient.whiteRum.id
            isShaking = false
            isPouring = false
            pouringIngredientID = nil
            isTransferringJigger = false
            phase = targetPhase
        }
    }
}

private enum GamePhase {
    case bar
    case mixing
    case score
}

private enum MojitoIngredient: String, CaseIterable, Identifiable {
    case whiteRum
    case limeJuice
    case syrup
    case soda
    case mint

    var id: String { rawValue }

    var name: String {
        switch self {
        case .whiteRum: "白朗姆"
        case .limeJuice: "青柠汁"
        case .syrup: "糖浆"
        case .soda: "苏打水"
        case .mint: "薄荷"
        }
    }

    var icon: String {
        switch self {
        case .whiteRum: "drop.fill"
        case .limeJuice: "leaf.fill"
        case .syrup: "takeoutbag.and.cup.and.straw.fill"
        case .soda: "bubbles.and.sparkles.fill"
        case .mint: "camera.macro"
        }
    }

    var targetAmount: Double {
        switch self {
        case .whiteRum: 45
        case .limeJuice: 15
        case .syrup: 15
        case .soda: 90
        case .mint: 8
        }
    }

    var stepAmount: Double {
        switch self {
        case .mint: 2
        default: 5
        }
    }

    var pourAmount: Double {
        switch self {
        case .soda: 6
        case .mint: 1
        default: 1.5
        }
    }

    var usesJigger: Bool {
        switch self {
        case .whiteRum, .limeJuice, .syrup:
            true
        case .soda, .mint:
            false
        }
    }

    var unit: String {
        switch self {
        case .mint: "片"
        default: "ml"
        }
    }

    var tint: Color {
        switch self {
        case .whiteRum: Color(red: 0.85, green: 0.95, blue: 0.92)
        case .limeJuice: Color(red: 0.45, green: 0.90, blue: 0.38)
        case .syrup: Color(red: 0.96, green: 0.82, blue: 0.36)
        case .soda: Color(red: 0.62, green: 0.90, blue: 1.0)
        case .mint: Color(red: 0.18, green: 0.74, blue: 0.40)
        }
    }

    var assetName: String {
        switch self {
        case .whiteRum:
            "bottle_white_rum"
        case .limeJuice:
            "bottle_lime_juice"
        case .syrup:
            "bottle_syrup"
        case .soda:
            "bottle_soda"
        case .mint:
            "mint_leaf"
        }
    }
}

private struct MojitoMix {
    var amounts: [String: Double] = [:]
    var iceCount = 0
    var shakeCount = 0
    var actionCount = 0

    var totalLiquid: Double {
        MojitoIngredient.allCases
            .filter { $0 != .mint }
            .reduce(0) { partial, ingredient in
                partial + amount(for: ingredient)
            }
    }

    var mintLeaves: Int {
        Int(amount(for: .mint))
    }

    var fillRatio: Double {
        min(totalLiquid / 190, 1)
    }

    var liquidColor: Color {
        let rum = amount(for: .whiteRum)
        let lime = amount(for: .limeJuice)
        let syrup = amount(for: .syrup)
        let soda = amount(for: .soda)
        let total = max(rum + lime + syrup + soda, 1)

        let red = (0.78 * rum + 0.38 * lime + 0.94 * syrup + 0.66 * soda) / total
        let green = (0.96 * rum + 0.88 * lime + 0.76 * syrup + 0.92 * soda) / total
        let blue = (0.88 * rum + 0.38 * lime + 0.30 * syrup + 0.98 * soda) / total

        return Color(red: red, green: green, blue: blue)
    }

    mutating func add(_ ingredient: MojitoIngredient) {
        amounts[ingredient.id, default: 0] += ingredient.stepAmount
        actionCount += 1
    }

    mutating func pour(_ ingredient: MojitoIngredient) {
        amounts[ingredient.id, default: 0] += ingredient.pourAmount
        actionCount += 1
    }

    mutating func add(_ ingredient: MojitoIngredient, amount: Double) {
        amounts[ingredient.id, default: 0] += amount
        actionCount += 1
    }

    mutating func addIce() {
        iceCount += 1
        actionCount += 1
    }

    mutating func shake() {
        shakeCount += 1
        actionCount += 1
    }

    func amount(for ingredient: MojitoIngredient) -> Double {
        amounts[ingredient.id, default: 0]
    }
}

private struct JiggerState {
    var ingredientID: String?
    var amount: Double = 0

    let capacity: Double = 60
    let marks: [Double] = [15, 30, 45, 60]

    var fillRatio: Double {
        min(amount / capacity, 1)
    }

    var isEmpty: Bool {
        amount <= 0
    }

    var activeIngredient: MojitoIngredient? {
        guard let ingredientID else {
            return nil
        }

        return MojitoIngredient.allCases.first { $0.id == ingredientID }
    }

    var nearestMark: Double? {
        marks.min { first, second in
            abs(first - amount) < abs(second - amount)
        }
    }

    mutating func pour(_ ingredient: MojitoIngredient) {
        if ingredientID != ingredient.id {
            ingredientID = ingredient.id
            amount = 0
        }

        amount = min(capacity, amount + ingredient.pourAmount)
    }

    mutating func snapToNearbyMark(threshold: Double = 1.6) -> Bool {
        guard let nearestMark, abs(amount - nearestMark) <= threshold else {
            return false
        }

        amount = nearestMark
        return true
    }

    mutating func empty() {
        ingredientID = nil
        amount = 0
    }
}

private struct MojitoScore {
    let total: Int
    let grade: String
    let feedback: [String]

    static let empty = MojitoScore(total: 0, grade: "D", feedback: [])
}

private enum MojitoScorer {
    static func score(_ mix: MojitoMix) -> MojitoScore {
        var points = 0.0
        var feedback: [String] = []

        let amountScore = MojitoIngredient.allCases.reduce(0.0) { partial, ingredient in
            let actual = mix.amount(for: ingredient)
            let target = ingredient.targetAmount
            let difference = abs(actual - target)
            let maxIngredientScore = 60.0 / Double(MojitoIngredient.allCases.count)
            let ingredientScore = max(0, maxIngredientScore * (1 - difference / max(target, 1)))

            if actual == 0 {
                feedback.append("缺少\(ingredient.name)，Mojito 的结构不完整。")
            } else if difference <= 5 || (ingredient == .mint && difference <= 2) {
                feedback.append("\(ingredient.name)用量很接近目标。")
            } else if actual > target {
                feedback.append("\(ingredient.name)偏多，风味会被拉偏。")
            } else {
                feedback.append("\(ingredient.name)偏少，层次会变弱。")
            }

            return partial + ingredientScore
        }

        points += amountScore

        let iceDifference = abs(mix.iceCount - 6)
        points += max(0, 10 - Double(iceDifference) * 2)
        if mix.iceCount == 0 {
            feedback.append("没有加冰，清爽度和温度都会不足。")
        } else if iceDifference <= 1 {
            feedback.append("冰块数量合适，口感会比较清爽。")
        } else if mix.iceCount > 6 {
            feedback.append("冰块偏多，饮品容易被过度稀释。")
        } else {
            feedback.append("冰块偏少，降温不足。")
        }

        points += min(Double(mix.shakeCount) / 3, 1) * 15
        if mix.shakeCount >= 3 {
            feedback.append("摇酒完成度不错，薄荷和青柠香气被带出来了。")
        } else {
            feedback.append("摇酒不足，香气和融合度还可以更好。")
        }

        let completedIngredients = MojitoIngredient.allCases.filter { mix.amount(for: $0) > 0 }.count
        points += Double(completedIngredients) / Double(MojitoIngredient.allCases.count) * 10
        points += mix.actionCount > 0 ? 5 : 0

        let total = min(100, max(0, Int(points.rounded())))
        let grade: String
        switch total {
        case 90...100: grade = "S"
        case 80..<90: grade = "A"
        case 70..<80: grade = "B"
        case 60..<70: grade = "C"
        default: grade = "D"
        }

        return MojitoScore(total: total, grade: grade, feedback: Array(feedback.prefix(5)))
    }
}

private struct BarHomeView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 12) {
                Text("MIXCRIT")
                    .font(.system(size: 46, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(red: 0.95, green: 0.76, blue: 0.36)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("P0: Mojito 调酒台原型")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.72))
            }

            BarCounterPreview()
                .frame(height: 250)
                .padding(.horizontal, 28)

            VStack(spacing: 10) {
                Text("今晚第一位客人想要一杯清爽、有薄荷香、不要太甜的 Mojito。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.82))
                    .padding(.horizontal, 34)

                Button(action: onStart) {
                    Label("开始营业", systemImage: "wineglass.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.15, green: 0.68, blue: 0.40))
                .padding(.horizontal, 36)
            }

            Spacer()
        }
    }
}

private struct BarCounterPreview: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.20, green: 0.13, blue: 0.08),
                            Color(red: 0.06, green: 0.04, blue: 0.03)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.10), lineWidth: 1)
                }

            HStack(alignment: .bottom, spacing: 22) {
                BottleView(color: Color(red: 0.84, green: 0.94, blue: 0.90), height: 150)
                BottleView(color: Color(red: 0.38, green: 0.86, blue: 0.42), height: 120)
                CocktailGlassView(mix: .preview, isShaking: false, motionTick: 0, fallingIceTick: 0, isFallingIceVisible: false)
                    .frame(width: 120, height: 190)
                BottleView(color: Color(red: 0.96, green: 0.78, blue: 0.30), height: 132)
            }
            .padding(.bottom, 28)

            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.28, green: 0.16, blue: 0.08))
                .frame(height: 46)
                .shadow(color: .black.opacity(0.35), radius: 14, y: -4)
        }
    }
}

private struct BottleView: View {
    let color: Color
    let height: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 5)
                .fill(color.opacity(0.8))
                .frame(width: 18, height: height * 0.28)
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.62))
                .frame(width: 44, height: height * 0.72)
                .overlay {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.white.opacity(0.24))
                        .frame(width: 28, height: height * 0.22)
                }
        }
        .overlay(alignment: .topLeading) {
            Capsule()
                .fill(.white.opacity(0.22))
                .frame(width: 8, height: height * 0.55)
                .padding(.leading, 10)
                .padding(.top, 12)
        }
    }
}

private struct MixingStationView: View {
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

    private var selectedIngredient: MojitoIngredient {
        ingredients.first { $0.id == selectedIngredientID } ?? .whiteRum
    }

    var body: some View {
        VStack(spacing: 14) {
            orderCard

            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.09, green: 0.10, blue: 0.10).opacity(0.92),
                                Color(red: 0.18, green: 0.11, blue: 0.07).opacity(0.92)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    }
                    .overlay(alignment: .top) {
                        Capsule()
                            .fill(Color(red: 0.98, green: 0.76, blue: 0.34).opacity(0.20))
                            .frame(width: 240, height: 18)
                            .blur(radius: 18)
                            .padding(.top, 20)
                    }
                    .overlay(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.30, green: 0.17, blue: 0.08),
                                        Color(red: 0.14, green: 0.08, blue: 0.04)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 58)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 10)
                            .shadow(color: .black.opacity(0.35), radius: 12, y: -4)
                    }

                HStack(alignment: .bottom, spacing: 20) {
                    JiggerView(jigger: jigger, targetAmount: selectedIngredient.usesJigger ? selectedIngredient.targetAmount : nil)
                        .frame(width: 104, height: 230)

                    CocktailGlassView(
                        mix: currentMix,
                        isShaking: isShaking,
                        motionTick: glassMotionTick,
                        fallingIceTick: fallingIceTick,
                        isFallingIceVisible: isFallingIceVisible
                    )
                        .frame(width: 188, height: 290)
                }
                .padding(.top, 26)

                if let pouringIngredient, isPouring {
                    PourStreamView(ingredient: pouringIngredient, pulse: pourPulse)
                        .frame(width: 130, height: 210)
                        .offset(x: pouringIngredient.usesJigger ? -64 : 58, y: -70)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                }

                if let ingredient = jigger.activeIngredient, isTransferringJigger {
                    JiggerTransferStreamView(ingredient: ingredient)
                        .frame(width: 160, height: 150)
                        .offset(x: 38, y: 6)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 330)
            .padding(.horizontal, 18)

            workbenchShelf
            actionPanel
        }
        .padding(.vertical, 14)
        .onDisappear {
            stopPouring()
            isTransferringJigger = false
        }
    }

    private var orderCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("订单")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color(red: 0.90, green: 0.75, blue: 0.42))
                    Text("Mojito")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("客人偏好")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.58))
                    Text("清爽 / 薄荷香 / 不太甜")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.84))
                }
            }

            Text("当前选择：\(selectedIngredient.name)，目标 \(Int(selectedIngredient.targetAmount))\(selectedIngredient.unit)")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.66))
            Text(instructionText)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.52))

            if let active = jigger.activeIngredient, jigger.amount > 0 {
                Text("量杯中还有 \(active.name) \(Int(jigger.amount.rounded()))ml，出杯会自动倒入杯中。")
                    .font(.caption2)
                    .foregroundStyle(Color(red: 0.95, green: 0.78, blue: 0.40))
            }
        }
        .padding(16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 18)
    }

    private var workbenchShelf: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("吧台材料架")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.white.opacity(0.68))
                Spacer()
                Text("按住物件操作")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.42))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ingredients) { ingredient in
                        BarIngredientObjectView(
                            ingredient: ingredient,
                            amount: currentMix.amount(for: ingredient),
                            isSelected: selectedIngredientID == ingredient.id,
                            isActive: isPouring && pouringIngredientID == ingredient.id,
                            onSelect: {
                                selectedIngredientID = ingredient.id
                            },
                            onStart: {
                                selectedIngredientID = ingredient.id
                                startPouring(ingredient)
                            },
                            onStop: stopPouring
                        )
                    }

                    IceBucketObjectView(count: currentMix.iceCount) {
                        addIce()
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.horizontal, 18)
    }

    private var actionPanel: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ActionButton(title: "量杯入杯", systemImage: "arrow.down.to.line.compact", tint: Color(red: 0.90, green: 0.78, blue: 0.52)) {
                    transferJiggerToGlass()
                }

                ActionButton(title: "清空量杯", systemImage: "xmark.circle.fill", tint: Color(red: 0.94, green: 0.48, blue: 0.38)) {
                    stopPouring()
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) {
                        jigger.empty()
                    }
                    hapticTick.toggle()
                }
            }

            HStack(spacing: 10) {
                ActionButton(title: "摇酒 \(currentMix.shakeCount)/3", systemImage: "hands.sparkles.fill", tint: Color(red: 0.95, green: 0.76, blue: 0.32)) {
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

                ActionButton(title: "出杯", systemImage: "checkmark.seal.fill", tint: Color(red: 0.26, green: 0.78, blue: 0.46)) {
                    finalizeAndServe()
                }
            }

            Button(role: .destructive, action: onReset) {
                Label("重置这杯", systemImage: "arrow.counterclockwise")
                    .font(.footnote.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.bordered)
            .tint(.white.opacity(0.75))
            .padding(.horizontal, 18)
        }
        .padding(.top, 2)
    }

    private var pouringIngredient: MojitoIngredient? {
        guard let pouringIngredientID else {
            return nil
        }

        return ingredients.first { $0.id == pouringIngredientID }
    }

    private var instructionText: String {
        if selectedIngredient.usesJigger {
            if let active = jigger.activeIngredient, !jigger.isEmpty {
                return "量杯中：\(active.name) \(Int(jigger.amount.rounded()))ml。到 15/30/45ml 刻度会震动提示。"
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

private struct JiggerView: View {
    let jigger: JiggerState
    let targetAmount: Double?

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let cupWidth = size.width * 0.56
            let cupHeight = size.height * 0.72
            let liquidHeight = max(4, cupHeight * 0.78 * jigger.fillRatio)
            let ingredient = jigger.activeIngredient

            VStack(spacing: 8) {
                ZStack(alignment: .bottom) {
                    Image("jigger_empty")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.18)
                        .frame(width: cupWidth * 1.95, height: cupHeight * 1.10)
                        .offset(y: -cupHeight * 0.03)

                    RoundedRectangle(cornerRadius: cupWidth * 0.18)
                        .fill(.white.opacity(0.07))
                        .frame(width: cupWidth, height: cupHeight)
                        .overlay {
                            RoundedRectangle(cornerRadius: cupWidth * 0.18)
                                .stroke(.white.opacity(0.46), lineWidth: 2)
                        }
                        .overlay(alignment: .trailing) {
                            markLayer(width: cupWidth, height: cupHeight)
                        }

                    RoundedRectangle(cornerRadius: cupWidth * 0.13)
                        .fill(
                            LinearGradient(
                                colors: [
                                    (ingredient?.tint ?? .white).opacity(0.78),
                                    (ingredient?.tint ?? .white).opacity(0.38)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: cupWidth * 0.78, height: liquidHeight)
                        .padding(.bottom, cupHeight * 0.08)
                        .animation(.spring(response: 0.24, dampingFraction: 0.78), value: jigger.amount)

                    Capsule()
                        .fill(.white.opacity(0.18))
                        .frame(width: 8, height: cupHeight * 0.68)
                        .offset(x: -cupWidth * 0.22, y: -cupHeight * 0.08)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 2) {
                    Text("JIGGER")
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundStyle(.white.opacity(0.58))
                    Text(jigger.isEmpty ? "空量杯" : "\(Int(jigger.amount.rounded()))ml")
                        .font(.caption.weight(.black))
                        .foregroundStyle(ingredient?.tint ?? .white.opacity(0.72))
                }
                .frame(height: 34)
            }
            .frame(width: size.width, height: size.height, alignment: .bottom)
        }
    }

    private func markLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack(alignment: .bottomTrailing) {
            ForEach(jigger.marks, id: \.self) { mark in
                let isTarget = targetAmount.map { abs($0 - mark) < 0.1 } ?? false
                let isReached = jigger.amount >= mark

                HStack(spacing: 4) {
                    Text("\(Int(mark))")
                        .font(.system(size: 9, weight: isTarget ? .black : .bold, design: .rounded))
                    Rectangle()
                        .frame(width: isTarget ? 24 : 16, height: isTarget ? 2 : 1)
                }
                .foregroundStyle(isTarget ? Color(red: 0.98, green: 0.78, blue: 0.26) : .white.opacity(isReached ? 0.86 : 0.38))
                .shadow(color: isTarget ? Color(red: 0.98, green: 0.78, blue: 0.26).opacity(0.55) : .clear, radius: 8)
                .offset(y: -height * 0.08 - height * 0.78 * CGFloat(mark / jigger.capacity))
            }
        }
        .frame(width: width, height: height)
        .padding(.trailing, -18)
    }
}

private struct JiggerTransferStreamView: View {
    let ingredient: MojitoIngredient

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(ingredient.tint.opacity(0.48))
                .frame(width: 72, height: 24)
                .rotationEffect(.degrees(-24))
                .offset(x: -36, y: -38)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white.opacity(0.22), lineWidth: 1)
                        .rotationEffect(.degrees(-24))
                        .offset(x: -36, y: -38)
                }

            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            ingredient.tint.opacity(0.90),
                            ingredient.tint.opacity(0.32)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 10, height: 116)
                .rotationEffect(.degrees(-22))
                .offset(x: 12, y: 10)
                .shadow(color: ingredient.tint.opacity(0.45), radius: 12)
        }
        .allowsHitTesting(false)
    }
}

private struct BarIngredientObjectView: View {
    let ingredient: MojitoIngredient
    let amount: Double
    let isSelected: Bool
    let isActive: Bool
    let onSelect: () -> Void
    let onStart: () -> Void
    let onStop: () -> Void

    @State private var didStart = false

    var body: some View {
        VStack(spacing: 7) {
            ingredientArtwork
                .frame(width: 58, height: 74)

            VStack(spacing: 2) {
                Text(ingredient.name)
                    .font(.caption2.weight(.black))
                    .lineLimit(1)
                Text("\(Int(amount))/\(Int(ingredient.targetAmount))\(ingredient.unit)")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.56))
            }
        }
        .frame(width: 84, height: 112)
        .foregroundStyle(.white)
        .background(
            LinearGradient(
                colors: [
                    .white.opacity(isSelected ? 0.18 : 0.08),
                    ingredient.tint.opacity(isSelected ? 0.20 : 0.06)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 14)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(ingredient.tint.opacity(isSelected ? 0.85 : 0.25), lineWidth: isSelected ? 2 : 1)
        }
        .shadow(color: ingredient.tint.opacity(isActive ? 0.35 : 0.08), radius: isActive ? 12 : 4, y: 4)
        .scaleEffect(isActive ? 0.97 : 1)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !didStart else {
                        return
                    }

                    didStart = true
                    onStart()
                }
                .onEnded { _ in
                    didStart = false
                    onStop()
                }
        )
        .onDisappear {
            didStart = false
            onStop()
        }
    }

    @ViewBuilder
    private var ingredientArtwork: some View {
        Image(ingredient.assetName)
            .resizable()
            .scaledToFit()
            .frame(
                width: ingredient == .mint ? 62 : 56,
                height: ingredient == .mint ? 56 : 74
            )
            .shadow(color: .black.opacity(0.22), radius: 6, y: 3)
    }
}

private struct IceBucketObjectView: View {
    let count: Int
    let onAddIce: () -> Void

    var body: some View {
        Button(action: onAddIce) {
            VStack(spacing: 7) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.55, green: 0.76, blue: 0.86).opacity(0.55),
                                    Color(red: 0.20, green: 0.28, blue: 0.34).opacity(0.82)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 58, height: 48)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.24), lineWidth: 1)
                        }

                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { index in
                            Image("ice_cube")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .rotationEffect(.degrees(Double(index * 14 - 10)))
                        }
                    }
                    .offset(y: -22)
                }
                .frame(width: 58, height: 74)

                VStack(spacing: 2) {
                    Text("冰桶")
                        .font(.caption2.weight(.black))
                    Text("\(count)/6 颗")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.56))
                }
            }
            .frame(width: 84, height: 112)
            .foregroundStyle(.white)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(red: 0.64, green: 0.88, blue: 1.0).opacity(0.34), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct PourButton: View {
    let title: String
    let systemImage: String
    let tint: Color
    let isActive: Bool
    let onStart: () -> Void
    let onStop: () -> Void

    @State private var didStart = false

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline.weight(.black))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [
                        tint.opacity(isActive ? 1.0 : 0.90),
                        tint.opacity(isActive ? 0.72 : 0.52)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 13)
            )
            .foregroundStyle(.black)
            .overlay {
                RoundedRectangle(cornerRadius: 13)
                    .stroke(.white.opacity(isActive ? 0.70 : 0.18), lineWidth: 1)
            }
            .scaleEffect(isActive ? 0.97 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.72), value: isActive)
            .padding(.horizontal, 18)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard !didStart else {
                            return
                        }

                        didStart = true
                        onStart()
                    }
                    .onEnded { _ in
                        didStart = false
                        onStop()
                    }
            )
            .onDisappear {
                didStart = false
                onStop()
            }
    }
}

private struct ActionButton: View {
    let title: String
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.black))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .foregroundStyle(.black)
        .padding(.horizontal, 18)
    }
}

private struct PourStreamView: View {
    let ingredient: MojitoIngredient
    let pulse: Bool

    var body: some View {
        VStack(spacing: 0) {
            BottlePourHead(ingredient: ingredient, pulse: pulse)
                .frame(width: 112, height: 72)
                .offset(x: -12, y: 12)

            ZStack {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                ingredient.tint.opacity(0.95),
                                ingredient.tint.opacity(0.42),
                                .white.opacity(0.20)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: ingredient == .mint ? 0 : 8, height: pulse ? 122 : 96)
                    .shadow(color: ingredient.tint.opacity(0.48), radius: 12)

                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(ingredient.tint.opacity(ingredient == .mint ? 0 : 0.62))
                        .frame(width: CGFloat(5 + index), height: CGFloat(5 + index))
                        .offset(
                            x: CGFloat(index - 2) * 7,
                            y: CGFloat(index * 22) + (pulse ? 14 : -6)
                        )
                        .opacity(pulse ? 0.95 : 0.45)
                }

                if ingredient == .mint {
                    ForEach(0..<5, id: \.self) { index in
                        Capsule()
                            .fill(ingredient.tint.opacity(0.90))
                            .frame(width: 9, height: 20)
                            .rotationEffect(.degrees(Double(index * 32)))
                            .offset(
                                x: CGFloat(index - 2) * 12,
                                y: CGFloat(index * 18) + (pulse ? 20 : 0)
                            )
                    }
                }
            }
            .frame(height: 138, alignment: .top)
        }
        .allowsHitTesting(false)
        .animation(.easeInOut(duration: 0.16), value: pulse)
    }
}

private struct BottlePourHead: View {
    let ingredient: MojitoIngredient
    let pulse: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(ingredient.tint.opacity(0.72))
                .frame(width: 78, height: 34)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.25), lineWidth: 1)
                }

            RoundedRectangle(cornerRadius: 5)
                .fill(ingredient.tint.opacity(0.90))
                .frame(width: 36, height: 16)
                .offset(x: 28)
        }
        .rotationEffect(.degrees(ingredient == .mint ? -14 : -28))
        .offset(x: pulse ? 4 : 0)
        .shadow(color: .black.opacity(0.28), radius: 12, y: 6)
    }
}

private struct CocktailGlassView: View {
    let mix: MojitoMix
    let isShaking: Bool
    let motionTick: Int
    let fallingIceTick: Int
    let isFallingIceVisible: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let glassWidth = size.width * 0.58
            let glassHeight = size.height * 0.86
            let liquidHeight = max(8, glassHeight * 0.64 * mix.fillRatio)
            let sloshOffset = motionTick.isMultiple(of: 2) ? -5.0 : 5.0

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: glassWidth * 0.12)
                    .fill(
                        LinearGradient(
                            colors: [
                                mix.liquidColor.opacity(0.80),
                                mix.liquidColor.opacity(0.48)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: glassWidth * 0.88, height: liquidHeight)
                    .overlay(alignment: .top) {
                        Capsule()
                            .fill(.white.opacity(0.30))
                            .frame(height: 8)
                            .offset(x: sloshOffset)
                            .rotationEffect(.degrees(motionTick.isMultiple(of: 2) ? -2 : 2))
                            .padding(.horizontal, 8)
                            .padding(.top, 3)
                    }
                    .padding(.bottom, glassHeight * 0.07)
                    .animation(.spring(response: 0.4, dampingFraction: 0.76), value: mix.totalLiquid)
                    .animation(.spring(response: 0.32, dampingFraction: 0.42), value: motionTick)

                if mix.amount(for: .soda) > 0 {
                    BubbleLayer(
                        width: glassWidth * 0.78,
                        height: max(20, liquidHeight - 8),
                        intensity: min(1, mix.amount(for: .soda) / MojitoIngredient.soda.targetAmount),
                        motionTick: motionTick
                    )
                    .padding(.bottom, glassHeight * 0.10)
                }

                iceLayer(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.10)

                FallingIceView(tick: fallingIceTick, isVisible: isFallingIceVisible)
                    .frame(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.05)

                mintLayer(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.14)

                if mix.amount(for: .limeJuice) > 0 {
                    limeGarnish(width: glassWidth, height: glassHeight)
                }

                Image("highball_glass_empty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: glassWidth * 1.52, height: glassHeight * 1.04)
                    .offset(y: -glassHeight * 0.015)
                    .allowsHitTesting(false)
            }
            .frame(width: size.width, height: size.height)
            .rotationEffect(.degrees(isShaking ? -4 : 0))
            .offset(x: isShaking ? 7 : 0)
            .animation(.linear(duration: 0.08), value: isShaking)
            .animation(.spring(response: 0.30, dampingFraction: 0.55), value: motionTick)
        }
    }

    private func iceLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            ForEach(0..<min(mix.iceCount, 10), id: \.self) { index in
                Image("ice_cube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .opacity(0.72)
                    .rotationEffect(.degrees(Double(index * 17)))
                    .offset(
                        x: CGFloat((index % 3) - 1) * 25,
                        y: -CGFloat(index / 3) * 24
                    )
            }
        }
        .frame(width: width, height: height * 0.42, alignment: .bottom)
    }

    private func mintLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            ForEach(0..<min(mix.mintLeaves, 10), id: \.self) { index in
                Image("mint_leaf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .opacity(0.90)
                    .rotationEffect(.degrees(Double(index * 31)))
                    .offset(
                        x: CGFloat((index % 4) - 2) * 18,
                        y: -CGFloat(index / 4) * 20
                    )
            }
        }
        .frame(width: width, height: height * 0.46, alignment: .bottom)
    }

    private func limeGarnish(width: CGFloat, height: CGFloat) -> some View {
        Image("lime_slice")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.34, height: width * 0.34)
            .rotationEffect(.degrees(-18))
            .offset(x: width * 0.26, y: -height * 0.70)
            .shadow(color: .black.opacity(0.22), radius: 5, y: 3)
            .allowsHitTesting(false)
    }
}

private struct FallingIceView: View {
    let tick: Int
    let isVisible: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            if tick > 0, isVisible {
                Image("ice_cube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .rotationEffect(.degrees(tick.isMultiple(of: 2) ? 18 : -18))
                    .offset(
                        x: size.width * 0.5 + CGFloat((tick % 3) - 1) * 20 - 13,
                        y: size.height * 0.15
                    )
                    .transition(.asymmetric(
                        insertion: .offset(y: -120).combined(with: .opacity),
                        removal: .scale(scale: 0.6).combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.38, dampingFraction: 0.45), value: tick)
            }
        }
        .allowsHitTesting(false)
    }
}

private struct BubbleLayer: View {
    let width: CGFloat
    let height: CGFloat
    let intensity: Double
    let motionTick: Int

    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                let progress = CGFloat((index * 17 + motionTick * 11) % 100) / 100
                let bubbleSize = CGFloat(4 + (index % 4) * 2)
                let xOffset = (CGFloat(index % 5) / 4 - 0.5) * width * 0.72
                let yOffset = -height * progress

                Circle()
                    .stroke(.white.opacity(0.28 + 0.34 * intensity), lineWidth: 1.2)
                    .background(Circle().fill(.white.opacity(0.05)))
                    .frame(width: bubbleSize, height: bubbleSize)
                    .offset(x: xOffset, y: yOffset)
                    .opacity(0.35 + 0.5 * intensity)
            }
        }
        .frame(width: width, height: height, alignment: .bottom)
        .animation(.easeInOut(duration: 0.45), value: motionTick)
        .allowsHitTesting(false)
    }
}

private struct ScoreView: View {
    let mix: MojitoMix
    let score: MojitoScore
    let onRetry: () -> Void
    let onBackToBar: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            CocktailGlassView(mix: mix, isShaking: false, motionTick: 0, fallingIceTick: 0, isFallingIceVisible: false)
                .frame(width: 190, height: 260)

            VStack(spacing: 8) {
                Text(score.grade)
                    .font(.system(size: 78, weight: .black, design: .rounded))
                    .foregroundStyle(gradeColor)
                Text("\(score.total) 分")
                    .font(.title.bold())
                Text(score.total >= 80 ? "客人很满意这杯 Mojito" : "这杯还可以再打磨一下")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.74))
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(score.feedback, id: \.self) { item in
                    Label(item, systemImage: "sparkle")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.82))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal, 24)

            HStack(spacing: 12) {
                Button(action: onRetry) {
                    Label("再调一杯", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.bordered)

                Button(action: onBackToBar) {
                    Label("回到酒吧", systemImage: "house.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.18, green: 0.70, blue: 0.42))
            }
            .font(.subheadline.weight(.bold))
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.vertical, 18)
    }

    private var gradeColor: Color {
        switch score.grade {
        case "S": Color(red: 0.98, green: 0.80, blue: 0.24)
        case "A": Color(red: 0.22, green: 0.82, blue: 0.48)
        case "B": Color(red: 0.48, green: 0.78, blue: 1.0)
        case "C": Color(red: 0.95, green: 0.60, blue: 0.24)
        default: Color(red: 0.95, green: 0.35, blue: 0.35)
        }
    }
}

private extension MojitoMix {
    static var preview: MojitoMix {
        var mix = MojitoMix()
        mix.amounts[MojitoIngredient.whiteRum.id] = 45
        mix.amounts[MojitoIngredient.limeJuice.id] = 20
        mix.amounts[MojitoIngredient.syrup.id] = 15
        mix.amounts[MojitoIngredient.soda.id] = 90
        mix.amounts[MojitoIngredient.mint.id] = 8
        mix.iceCount = 6
        mix.shakeCount = 3
        return mix
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
