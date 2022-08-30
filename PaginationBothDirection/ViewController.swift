//
//  ViewController.swift
//  PaginationBothDirection
//
//  Created by Yannic Borgfeld on 25.08.22.
//

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

protocol CellController {
    func cell(in tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func willDisplay()
}

extension CellController {
    func willDisplay() {}
}

struct Model: Hashable {
    let uuid: UUID
    let height: CGFloat
    
    static func createUnique() -> Model {
        .init(uuid: UUID(), height: .random(in: 50...300))
    }
}

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

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
        
    private var models = [Model]()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, HashableCellController> = {
        .init(tableView: tableView) { tableView, indexPath, cellController in
            cellController.cellController.cell(in: tableView, forRowAt: indexPath)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        models = (1...40).map { _ in Model.createUnique() }
        updateTableView()
        tableView.scrollToRow(at: IndexPath(row: 20, section: 0), at: .middle, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.cellController.willDisplay()
    }
    
    private func updateTableView() {
        var cellControllers = [HashableCellController]()
        
        cellControllers.append(HashableCellController(hashable: UUID(), cellController: LoadingCellController(load: { [weak self] in self?.loadPrevious()
        })))
        
        cellControllers.append(contentsOf: models.map {
            return HashableCellController(hashable: $0, cellController: ModelCellController(model: $0))
        })
        
        cellControllers.append(HashableCellController(hashable: UUID(), cellController: LoadingCellController(load: { [weak self] in self?.loadNext()
        })))
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, HashableCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func loadPrevious() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let models = (1...20).map { _ in Model.createUnique() }
            self.models.insert(contentsOf: models, at: 0)
            self.updateTableView()
        }
    }
    
    private func loadNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let models = (1...20).map { _ in Model.createUnique() }
            self.models.append(contentsOf: models)
            self.updateTableView()
        }
    }
}

