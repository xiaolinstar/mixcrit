import SwiftUI

public struct MixingOnboardingOverlay: View {
    public let step: Int
    public let layout: ScreenLayout
    public let onNext: () -> Void
    public let onSkip: () -> Void

    public init(step: Int, layout: ScreenLayout, onNext: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.step = step
        self.layout = layout
        self.onNext = onNext
        self.onSkip = onSkip
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.28)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: max(8, 10 * layout.scale)) {
                    HStack {
                        Text("第 \(min(step + 1, 3)) 步 / 3")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color(red: 0.95, green: 0.78, blue: 0.42))

                        Spacer()

                        Button("跳过引导", action: onSkip)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.72))
                    }

                    Text(title)
                        .font(.system(size: max(18, 22 * layout.scale), weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)

                    Text(detail)
                        .font(.system(size: max(12, 14 * layout.scale), weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.78))
                        .lineLimit(4)
                        .minimumScaleFactor(0.72)

                    Button(action: onNext) {
                        Text(buttonTitle)
                            .font(.system(size: max(13, 15 * layout.scale), weight: .black, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .frame(height: max(34, 40 * layout.scale))
                            .foregroundStyle(.black)
                            .background(Color(red: 0.78, green: 0.93, blue: 0.56), in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(max(14, 18 * layout.scale))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.24), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.35), radius: 24, y: 12)
                .padding(.horizontal, layout.horizontalPadding)
                .padding(.bottom, layout.controlDockHeight + max(10, 14 * layout.scale))
            }
        }
    }

    private var title: String {
        switch step {
        case 0:
            return "点击原料，装入 15ml 量杯"
        case 1:
            return "点「量杯入杯」倒入成品杯"
        default:
            return "补料、加冰、摇酒、出杯"
        }
    }

    private var detail: String {
        switch step {
        case 0:
            return "点击下方白朗姆、青柠汁或糖浆，每次点击装入 15ml。白朗姆 45ml 需要重复 3 次「装量杯→入杯」。"
        case 1:
            return "量杯装满后，点底部「量杯入杯」，15ml 才会进入右侧成品杯。青柠汁、糖浆各装 1 次即可。"
        default:
            return "苏打水每次 +30ml、薄荷每次 +2 片，直接入杯。最后加冰 6 颗、摇酒 3 次，点「出杯」评分。"
        }
    }

    private var buttonTitle: String {
        step >= 2 ? "开始调酒" : "知道了"
    }
}
