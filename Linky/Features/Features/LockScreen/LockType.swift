//
//  LockType.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

enum LockType {
    case nomal
    case newPassword // 비밀 번호 입력해주세요.
    case changePassword // 비밃 번호 바꾸기
    
    var title: String {
        switch self {
        case .nomal, .newPassword:
            return "비밀번호 입력"
        case .changePassword:
            return "새로운 암호 입력"
        }
    }
    
    var subtitle: String {
        switch self {
        case .nomal, .newPassword:
            return "비밀번호 네 자리를 입력해 주세요."
        case .changePassword:
            return "새로운 암호를 입력해 주세요."
        }
    }
    
    var invalidText: String {
        "전에 입력한 번호와 일치하지 않아요."
    }
    
    var pads: [[PadView.PadType]] {
        return [[.number(1), .number(2), .number(3)],
                [.number(4), .number(5), .number(6)],
                [.number(7), .number(8), .number(9)],
                [leftBottomPad, .number(0), .back]]
    }
    
    private var leftBottomPad: PadView.PadType {
        switch self {
        case .nomal: return .biometricsAuth
        case .newPassword, .changePassword: return .cancle
        }
    }
}
