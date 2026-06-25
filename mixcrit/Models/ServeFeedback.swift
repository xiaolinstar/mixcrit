import Foundation

public struct ServeFeedback {
    public let total: Int
    public let grade: String
    public let customerLine: String
    public let tags: [String]
    public let coins: Int
    public let experience: Int
    public let satisfaction: Int

    public var asMojitoScore: MojitoScore {
        MojitoScore(total: total, grade: grade, feedback: tags)
    }

    public static let empty = ServeFeedback(
        total: 0,
        grade: "D",
        customerLine: "这杯还需要再调整一下。",
        tags: [],
        coins: 0,
        experience: 0,
        satisfaction: 0
    )
}
