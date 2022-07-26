//
//  TableView.swift
//  Animations
//
//  Created by Vladimir Gusev on 23.07.2022.
//

import UIKit

final class TableView: UITableView {
    var handleSelection: ((Item) -> Void)?
    
    private var itemSet = Set(
        (0...2).compactMap { _ in Item.allCases.randomElement() }
    )
    
    private lazy var diffableDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: self) {
        tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .none
        cell.textLabel?.text = item.rawValue
        cell.imageView?.image = .init(item: item)
        return cell
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource = diffableDataSource
        delegate = self
        updateSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addItem(_ item: Item) {
        itemSet.insert(item)
        updateSnapshot()
    }
}

// MARK: - Private
private extension TableView {
    typealias Section = Bool
    
    var itemArray: [Item] {
        Item.allCases.filter(itemSet.contains)
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.init()])
        snapshot.appendItems(itemArray)
        diffableDataSource.apply(snapshot)
    }
}

// MARK: - UITableViewDelegate
extension TableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        handleSelection?(itemArray[indexPath.row])
    }
}

