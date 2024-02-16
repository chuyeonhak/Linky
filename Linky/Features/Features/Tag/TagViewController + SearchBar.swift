//
//  TagViewController + SearchBar.swift
//  Features
//
//  Created by chuchu on 2023/07/12.
//

import UIKit

import Core

extension TagViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowwerText = searchText.lowercased()
        var dataSource: [TagData] {
            searchText.isEmpty ?
            baseTagList:
            baseTagList.filter({ $0.title.lowercased().contains(lowwerText)})
        }
        
        tagView.baseDataSource = dataSource
        tagView.tagCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        checkLinkList()
    }
}
