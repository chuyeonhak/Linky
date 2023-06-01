//
//  MoreView + TableView.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

extension MoreView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingType.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MoreCell.identifier,
            for: indexPath) as? MoreCell,
              let type = SettingType.allCases[safe: indexPath.row]
            else { return UITableViewCell() }
        
        cell.configure(type: type)
        return cell
    }
}

extension MoreView: UITableViewDelegate {
    
}


