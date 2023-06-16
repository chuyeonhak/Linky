//
//  TagManageViewController + Type.swift
//  Features
//
//  Created by chuchu on 2023/06/15.
//

import UIKit

enum TagManageType {
    case add
    case edit
    case delete
    
    var title: String {
        switch self {
        case .add: return "태그 추가"
        case .edit: return "태그 이름 변경"
        case .delete: return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .add: return ""
        case .edit: return "새로운 태그 이름을 입력해주세요."
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
