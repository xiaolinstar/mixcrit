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
        #if DEBUG
        .onAppear(perform: applyDebugLaunchPhaseIfNeeded)
        #endif
    }

    #if DEBUG
    private func applyDebugLaunchPhaseIfNeeded() {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-uiqa-mixing") {
            phase = .mixing
        } else if arguments.contains("-uiqa-score") {
            currentMix = .preview
            lastScore = MojitoScorer.score(currentMix)
            phase = .score
        }
    }
    #endif

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
