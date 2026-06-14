import SwiftUI

public struct MojitoScore {
    public let total: Int
    public let grade: String
    public let feedback: [String]

    public static let empty = MojitoScore(total: 0, grade: "D", feedback: [])
}
