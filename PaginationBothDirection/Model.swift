import UIKit

struct Model: Hashable {
    let uuid: UUID
    let height: CGFloat
    
    static func createUnique() -> Model {
        .init(uuid: UUID(), height: .random(in: 50...300))
    }
}
