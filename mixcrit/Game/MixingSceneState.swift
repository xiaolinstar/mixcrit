import Foundation

public struct MixingSceneState: Equatable {
    public var selectedIngredientID: String
    public var selectedIngredientUsesJigger: Bool
    public var selectedIngredientTargetAmount: Double
    public var jiggerIngredientID: String?
    public var jiggerAmount: Double
    public var jiggerCapacity: Double
    public var glassFillRatio: Double
    public var iceCount: Int
    public var mintLeaves: Int
    public var hasLime: Bool
    public var hasSoda: Bool
    public var isPouring: Bool
    public var pouringIngredientID: String?
    public var isTransferringJigger: Bool
    public var isShaking: Bool

    public init(
        selectedIngredientID: String,
        selectedIngredientUsesJigger: Bool,
        selectedIngredientTargetAmount: Double,
        jiggerIngredientID: String?,
        jiggerAmount: Double,
        jiggerCapacity: Double,
        glassFillRatio: Double,
        iceCount: Int,
        mintLeaves: Int,
        hasLime: Bool,
        hasSoda: Bool,
        isPouring: Bool,
        pouringIngredientID: String?,
        isTransferringJigger: Bool,
        isShaking: Bool
    ) {
        self.selectedIngredientID = selectedIngredientID
        self.selectedIngredientUsesJigger = selectedIngredientUsesJigger
        self.selectedIngredientTargetAmount = selectedIngredientTargetAmount
        self.jiggerIngredientID = jiggerIngredientID
        self.jiggerAmount = jiggerAmount
        self.jiggerCapacity = jiggerCapacity
        self.glassFillRatio = glassFillRatio
        self.iceCount = iceCount
        self.mintLeaves = mintLeaves
        self.hasLime = hasLime
        self.hasSoda = hasSoda
        self.isPouring = isPouring
        self.pouringIngredientID = pouringIngredientID
        self.isTransferringJigger = isTransferringJigger
        self.isShaking = isShaking
    }
}
