import UIKit

protocol CellController {
    func cell(in tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func willDisplay()
}

extension CellController {
    func willDisplay() {}
}
