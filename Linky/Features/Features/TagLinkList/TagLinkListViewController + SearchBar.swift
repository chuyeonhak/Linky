//
//  TagLinkListViewController + SearchBar.swift
//  Features
//
//  Created by chuchu on 2023/07/13.
//

import UIKit

import Core

extension TagLinkListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let lowwerText = searchText.lowercased()
        
        var dataSources: [Link] {
            if searchText.isEmpty {
                return linkList
            } else {
                return linkList.filter({
                    let titleContains = $0.content?.title?.lowercased().contains(lowwerText)
                    let subtitleContains = $0.content?.subtitle?.lowercased().contains(lowwerText)
                    
                    return titleContains == true || subtitleContains == true })
            }
        }
        
        tagLinkListView.linkList = dataSources
        tagLinkListView.linkCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tagLinkListView.linkList = linkList
        tagLinkListView.linkCollectionView.reloadData()
    }
}
