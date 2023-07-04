//
//  OpenGraphManager.swift
//  Core
//
//  Created by chuchu on 2023/06/30.
//

import Foundation

import Alamofire
import OpenGraph

public struct OpenGraphManager {
    public static let shared = OpenGraphManager()
    
    public func getMetaData(urlString: String,
                            completion: ((MetaData) -> ())? = nil) {
        getHtml(urlString) { html in
            if let html,
               case let openGraph = OpenGraph(htmlString: html) {
                completion?(MetaData(openGraph: openGraph, url: urlString))
            } else {
                completion?(MetaData(url: urlString))
            }
        }
    }
    
    private func getHtml(_ urlString: String, completion: ((String?) -> ())? = nil) {
        AF.request(urlString).responseString { response in
            if let html = response.value {
                completion?(html)
            } else {
                completion?(nil)
            }
        }
    }
}
