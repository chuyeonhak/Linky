//
//  TagManageType.swift
//  Features
//
//  Created by chuchu on 2023/06/15.
//

import UIKit

import Core

enum TagManageType {
    case add
    case edit
    case delete
    
    var title: String {
        switch self {
        case .add: return I18N.addTag
        case .edit: return I18N.changeTagName
        case .delete: return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .add: return ""
        case .edit: return I18N.addNewTagSubtitle
        case .delete: return ""
        }
    }
    
    var placeholder: String {
        switch self {
        case .add: return I18N.addTagPlaceholder
        case .edit: return I18N.changeTagSubtitle
        case .delete: return ""
        }
    }
    
    var onImage: UIImage? {
        let on = "On"
        return UIImage(named: imageString + on)
    }
    
    var offImage: UIImage?  {
        let off = "Off"
        return UIImage(named: imageString + off)
    }
    
    private var imageString: String {
        switch self {
        case .add: return ""
        case .edit: return "icoEdit"
        case .delete: return "icoTrashCan"
        }
    }
}
