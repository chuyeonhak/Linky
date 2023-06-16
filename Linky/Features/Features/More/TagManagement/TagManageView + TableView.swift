//
//  TagManageView + TableView.swift
//  Features
//
//  Created by chuchu on 2023/06/15.
//

import UIKit

import Core

import Then

extension TagManageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectedItems.indices ~= indexPath.row else { return }
//
        selectedItems[indexPath.row] = !selectedItems[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension TagManageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedItems.count
//        UserDefaultsManager.shared.tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TagManageCell.identifier,
                                                       for: indexPath) as? TagManageCell
        else { return UITableViewCell() }
        
        let tagData = TagData(tagNo: 3, title: "wow", creationDate: Date())
        
        cell.configure(data: tagData, isSelected: selectedItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "삭제") { action, view, success in
            self.selectedItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }.then {
            $0.backgroundColor = .error
        }
        
        let editAction = UIContextualAction(style: .normal,
                                              title: "수정") { action, view, success in
            print("edit")
        }.then {
            $0.backgroundColor = .code4
        }
        
        return getSwipeActionConfig(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    private func getSwipeActionConfig(actions: [UIContextualAction]) -> UISwipeActionsConfiguration {
        let config = UISwipeActionsConfiguration(actions: actions)
        
//        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}
