import SwiftUI

public struct SimplifiedMixingView: View {
    @Binding var mixState: SimplifiedMixState

    let onServe: () -> Void
    let onBack: () -> Void

    public init(
        mixState: Binding<SimplifiedMixState>,
        onServe: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self._mixState = mixState
        self.onServe = onServe
        self.onBack = onBack
    }

    public var body: some View {
        GeometryReader { proxy in
            let layout = ScreenLayout(size: proxy.size, safeArea: proxy.safeAreaInsets)

            VStack(spacing: max(8, layout.sectionSpacing * 1.5)) {
                header(layout: layout)

                CocktailGlassView(
                    mix: mixState.previewMix,
                    isShaking: mixState.techniqueSteps > 0,
                    motionTick: mixState.techniqueSteps,
                    fallingIceTick: 0,
                    isFallingIceVisible: false
                )
                .frame(height: layout.contentHeight * (layout.isCompact ? 0.24 : 0.30))
                .frame(maxWidth: .infinity)

                controls(layout: layout)

                HStack(spacing: max(8, 12 * layout.scale)) {
                    Button(action: onBack) {
                        Label("旧流程", systemImage: "arrow.left")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, max(9, 12 * layout.scale))
                    }
                    .buttonStyle(.bordered)

                    Button(action: stir) {
                        Label("摇拌 \(min(mixState.techniqueSteps, 3))/3", systemImage: "hands.sparkles.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, max(9, 12 * layout.scale))
                    }
                    .buttonStyle(.bordered)
                    .tint(Color(red: 0.95, green: 0.76, blue: 0.32))

                    Button(action: onServe) {
                        Label("出杯", systemImage: "checkmark.seal.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, max(9, 12 * layout.scale))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.20, green: 0.72, blue: 0.42))
                }
                .font((layout.isCompact ? Font.caption : Font.subheadline).weight(.bold))
                .padding(.horizontal, layout.horizontalPadding)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .padding(.top, max(6, layout.verticalPadding))
            .padding(.bottom, max(8, layout.verticalPadding))
        }
    }

    private func header(layout: ScreenLayout) -> some View {
        VStack(alignment: .leading, spacing: max(6, 8 * layout.scale)) {
            HStack {
                Label("P0.12 简化 Mojito", systemImage: "person.fill.checkmark")
                    .font(.system(size: max(14, 17 * layout.scale), weight: .black, design: .rounded))
                Spacer()
                Menu {
                    ForEach(CustomerPreference.allCases) { preference in
                        Button(preference.title) {
                            mixState.preference = preference
                        }
                    }
                } label: {
                    Label(mixState.preference.title, systemImage: "slider.horizontal.3")
                        .font(.caption.weight(.bold))
                }
            }

            Text(mixState.preference.orderLine)
                .font(.system(size: max(12, 14 * layout.scale), weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.78))
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
        .padding(.horizontal, max(12, 14 * layout.scale))
        .padding(.vertical, max(10, 12 * layout.scale))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(mixState.preference.tint.opacity(0.38), lineWidth: 1)
        }
        .padding(.horizontal, layout.horizontalPadding)
    }

    private func controls(layout: ScreenLayout) -> some View {
        VStack(spacing: max(7, 9 * layout.scale)) {
            dialRow(kind: .rum, selection: $mixState.rum, tint: Color(red: 0.90, green: 0.88, blue: 0.76))
            dialRow(kind: .sweetness, selection: $mixState.sweetness, tint: Color(red: 0.96, green: 0.76, blue: 0.34))
            dialRow(kind: .mint, selection: $mixState.mint, tint: Color(red: 0.25, green: 0.78, blue: 0.42))
            dialRow(kind: .ice, selection: $mixState.ice, tint: Color(red: 0.62, green: 0.90, blue: 1.0))
        }
        .padding(.horizontal, layout.horizontalPadding)
    }

    private func dialRow(kind: MixControlKind, selection: Binding<MixDial>, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text(kind.title)
                    .font(.caption.weight(.black))
                    .foregroundStyle(tint)
                    .frame(width: 52, alignment: .leading)

                Picker(kind.title, selection: selection) {
                    ForEach(MixDial.allCases) { dial in
                        Text(kind.optionTitle(for: dial)).tag(dial)
                    }
                }
                .pickerStyle(.segmented)
            }

            Text(kind.lesson(for: selection.wrappedValue))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.68))
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
        .padding(8)
        .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
    }

    private func stir() {
        withAnimation(.spring(response: 0.22, dampingFraction: 0.72)) {
            mixState.techniqueSteps = min(mixState.techniqueSteps + 1, 3)
        }
    }
}
