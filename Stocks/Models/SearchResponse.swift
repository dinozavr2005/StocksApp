//
//  SearchResponse.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 30.01.2023.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
