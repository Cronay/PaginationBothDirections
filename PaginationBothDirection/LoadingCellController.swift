import UIKit

class LoadingCellController: CellController {
    let load: () -> Void
    
    init(load: @escaping () -> Void) {
        self.load = load
    }
    
    func cell(in tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as! LoadingCell
        cell.spinner.startAnimating()
        return cell
    }
    
    func willDisplay() {
        load()
    }
}
