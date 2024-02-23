//
//  NetworkManager.swift
//  CoreInterface
//
//  Created by chuchu on 2/23/24.
//

import Foundation

import Alamofire

public struct NetworkManager {
    public static let shared = NetworkManager()
    @frozen
    public enum API {
        case error(SlackMessageModel)
        case want(SlackMessageModel)
        case etc(SlackMessageModel)
        
        var urlString: String {
            switch self {
            case .error(_):
                "https://hooks.slack.com/services/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"
            case .want(_):
                "https://hooks.slack.com/services/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"
            case .etc(_):
                "https://hooks.slack.com/services/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"
            }
        }
        var url: URL { URL(string: urlString)! }
        
        var method: HTTPMethod {
            switch self {
            case .error(_), .want(_), .etc(_): .post
            }
        }
        
        var parameters: [String: Any] {
            switch self {
            case .error(let model), .want(let model), .etc(let model): model.json
            }
        }
        
        var encoder: ParameterEncoding {
            switch self {
            case .error(_), .want(_), .etc(_): JSONEncoding()
            }
        }
        
        var headers: HTTPHeaders { ["Content-Type": "application/json"] }
    }
    
    public func request(api: API, completion: @escaping (AFDataResponse<Data?>) -> Void) {
        AF.request(api.url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoder,
                   headers: api.headers).response(completionHandler: completion)
    }
}
