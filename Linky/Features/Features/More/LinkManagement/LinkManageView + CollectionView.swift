//
//  LinkManageView + TableView.swift
//  Features
//
//  Created by chuchu on 2023/06/22.
//

import UIKit

import Core

extension LinkManageView: UITableViewDelegate {
    
}

extension LinkManageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaultsManager.shared.linkList.filter({ $0.isRemoved }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LinkManageCell.identifier,
                                                       for: indexPath) as? LinkManageCell,
              case let linkList = UserDefaultsManager.shared.linkList.filter({ $0.isRemoved }),
              let linkData = linkList[safe: indexPath.row]
        else { return UITableViewCell() }
        
        print()
        
//        cell.configure(data: tagData, isSelected: selectedItems[indexPath.row])
        
        return cell
    }
    
    
}
