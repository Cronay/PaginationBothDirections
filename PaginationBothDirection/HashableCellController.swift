import UIKit

struct HashableCellController: Hashable {
    let hashable: AnyHashable
    let cellController: CellController
    
    static func == (lhs: HashableCellController, rhs: HashableCellController) -> Bool {
        lhs.hashable == rhs.hashable
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashable)
    }
}
