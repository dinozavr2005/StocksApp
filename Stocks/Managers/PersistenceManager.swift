//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.01.2023.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()

    private let userDefaults: UserDefaults = .standard

    private struct Constants {
        
    }

    private init() {}

    // MARK: - Public

    public var watchlist: [String] {
        return []
    }

    public func addToWatchlist() {

    }

    public func removeFromWatchList() {

    }

    // MARK: - Private

    private var hasOnboarded: Bool {
        return false
    }
}
