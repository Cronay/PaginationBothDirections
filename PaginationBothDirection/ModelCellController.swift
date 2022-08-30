import UIKit

class ModelCellController: CellController {
    let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    func cell(in tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(model.uuid)"
        cell.heightAnchor.constraint(equalToConstant: model.height).isActive = true
        return cell
    }
}
