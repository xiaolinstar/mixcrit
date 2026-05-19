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
    @State private var lastScore: MojitoScore?
    @State private var isShaking = false

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
                    isShaking: $isShaking,
                    ingredients: ingredients,
                    onServe: serveDrink,
                    onReset: resetDrink
                )
            case .score:
                ScoreView(
                    mix: currentMix,
                    score: lastScore ?? MojitoScore.empty,
                    onRetry: resetDrink,
                    onBackToBar: {
                        resetDrink()
                        phase = .bar
                    }
                )
            }
        }
        .preferredColorScheme(.dark)
    }

    private func serveDrink() {
        lastScore = MojitoScorer.score(currentMix)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
            phase = .score
        }
    }

    private func resetDrink() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
            currentMix = MojitoMix()
            selectedIngredientID = MojitoIngredient.whiteRum.id
            isShaking = false
            phase = .mixing
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
        case .limeJuice: 20
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
                CocktailGlassView(mix: .preview, isShaking: false)
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
    @Binding var isShaking: Bool

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
                    .fill(.black.opacity(0.24))
                    .overlay {
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    }

                CocktailGlassView(mix: currentMix, isShaking: isShaking)
                    .frame(width: 210, height: 300)
                    .padding(.top, 14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 330)
            .padding(.horizontal, 18)

            ingredientGrid
            actionPanel
        }
        .padding(.vertical, 14)
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

            Text("当前选择：\(selectedIngredient.name)，每次加入 \(Int(selectedIngredient.stepAmount))\(selectedIngredient.unit)")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.66))
        }
        .padding(16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 18)
    }

    private var ingredientGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(ingredients) { ingredient in
                Button {
                    selectedIngredientID = ingredient.id
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: ingredient.icon)
                            .font(.title3)
                        Text(ingredient.name)
                            .font(.caption.weight(.bold))
                        Text("\(Int(currentMix.amount(for: ingredient)))/\(Int(ingredient.targetAmount))\(ingredient.unit)")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.62))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 78)
                    .foregroundStyle(selectedIngredientID == ingredient.id ? .black : .white)
                    .background(
                        selectedIngredientID == ingredient.id
                        ? ingredient.tint
                        : .white.opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 14)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(ingredient.tint.opacity(selectedIngredientID == ingredient.id ? 0 : 0.5), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
    }

    private var actionPanel: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                ActionButton(title: "加入", systemImage: "plus.circle.fill", tint: selectedIngredient.tint) {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                        currentMix.add(selectedIngredient)
                    }
                }

                ActionButton(title: "加冰", systemImage: "cube.fill", tint: Color(red: 0.64, green: 0.88, blue: 1.0)) {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.66)) {
                        currentMix.addIce()
                    }
                }
            }

            HStack(spacing: 10) {
                ActionButton(title: "摇酒 \(currentMix.shakeCount)/3", systemImage: "hands.sparkles.fill", tint: Color(red: 0.95, green: 0.76, blue: 0.32)) {
                    currentMix.shake()
                    withAnimation(.linear(duration: 0.08).repeatCount(6, autoreverses: true)) {
                        isShaking = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        isShaking = false
                    }
                }

                ActionButton(title: "出杯", systemImage: "checkmark.seal.fill", tint: Color(red: 0.26, green: 0.78, blue: 0.46), action: onServe)
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

private struct CocktailGlassView: View {
    let mix: MojitoMix
    let isShaking: Bool

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let glassWidth = size.width * 0.58
            let glassHeight = size.height * 0.86
            let liquidHeight = max(8, glassHeight * 0.64 * mix.fillRatio)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: glassWidth * 0.16)
                    .fill(.white.opacity(0.08))
                    .frame(width: glassWidth, height: glassHeight)
                    .overlay {
                        RoundedRectangle(cornerRadius: glassWidth * 0.16)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.58), .white.opacity(0.10)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    }
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.22))
                            .frame(width: 10, height: glassHeight * 0.72)
                            .padding(.leading, 18)
                            .padding(.bottom, 16)
                    }

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
                            .padding(.horizontal, 8)
                            .padding(.top, 3)
                    }
                    .padding(.bottom, glassHeight * 0.07)
                    .animation(.spring(response: 0.4, dampingFraction: 0.76), value: mix.totalLiquid)

                iceLayer(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.10)

                mintLayer(width: glassWidth, height: glassHeight)
                    .padding(.bottom, glassHeight * 0.14)
            }
            .frame(width: size.width, height: size.height)
            .rotationEffect(.degrees(isShaking ? -4 : 0))
            .offset(x: isShaking ? 7 : 0)
            .animation(.linear(duration: 0.08), value: isShaking)
        }
    }

    private func iceLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            ForEach(0..<min(mix.iceCount, 10), id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(0.50))
                    .frame(width: 24, height: 20)
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
                Capsule()
                    .fill(Color(red: 0.15, green: 0.68, blue: 0.28).opacity(0.86))
                    .frame(width: 10, height: 22)
                    .rotationEffect(.degrees(Double(index * 31)))
                    .offset(
                        x: CGFloat((index % 4) - 2) * 18,
                        y: -CGFloat(index / 4) * 20
                    )
            }
        }
        .frame(width: width, height: height * 0.46, alignment: .bottom)
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

            CocktailGlassView(mix: mix, isShaking: false)
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
