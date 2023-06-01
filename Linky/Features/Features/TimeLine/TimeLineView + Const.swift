//
//  TimeLineView + Const.swift
//  Features
//
//  Created by chuchu on 2023/05/31.
//

import UIKit

extension TimeLineView {
    struct Const {
        enum Asset {
            case clock
            
            var image: UIImage? {
                switch self {
                case .clock: return UIImage(named: "clock")
                }
            }
        }
        
        enum Text {
            static let emptyTitle = "내가 추가한 링크를\n시간 순서대로 볼 수 있어요."
            static let addLink = "링크 추가하기"
        }
    }
}

