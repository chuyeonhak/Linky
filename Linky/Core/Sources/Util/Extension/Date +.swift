//
//  Date +.swift
//  Core
//
//  Created by chuchu on 2023/07/20.
//

import Foundation

public extension Date {
    func dateToString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: self)
    }
}
