import SwiftUI

public struct JiggerView: View {
    public let jigger: JiggerState
    public let targetAmount: Double?

    public init(jigger: JiggerState, targetAmount: Double?) {
        self.jigger = jigger
        self.targetAmount = targetAmount
    }

    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let cupWidth = size.width * 0.56
            let cupHeight = size.height * 0.86
            let liquidHeight = max(4, cupHeight * 0.78 * jigger.fillRatio)
            let ingredient = jigger.activeIngredient

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Image("jigger_empty")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.14)
                        .frame(width: cupWidth * 1.56, height: cupHeight * 1.04)
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
            }
            .frame(width: size.width, height: size.height, alignment: .bottom)
        }
    }

    private func markLayer(width: CGFloat, height: CGFloat) -> some View {
        ZStack(alignment: .bottomTrailing) {
            ForEach(jigger.marks, id: \.self) { mark in
                let isTarget = targetAmount.map { abs($0 - mark) < 0.1 } ?? false
                let isReached = jigger.amount >= mark

                HStack(spacing: 3) {
                    Text("\(Int(mark))")
                        .font(.system(size: max(7, width * 0.13), weight: isTarget ? .black : .bold, design: .rounded))
                    Rectangle()
                        .frame(width: isTarget ? width * 0.30 : width * 0.20, height: isTarget ? 2 : 1)
                }
                .foregroundStyle(isTarget ? Color(red: 0.98, green: 0.78, blue: 0.26) : .white.opacity(isReached ? 0.86 : 0.38))
                .shadow(color: isTarget ? Color(red: 0.98, green: 0.78, blue: 0.26).opacity(0.55) : .clear, radius: 8)
                .frame(width: width * 0.78, alignment: .trailing)
                .offset(y: -height * 0.08 - height * 0.78 * CGFloat(mark / jigger.capacity))
            }
        }
        .frame(width: width, height: height)
        .padding(.trailing, width * 0.08)
    }
}
