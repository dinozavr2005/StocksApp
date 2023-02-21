//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.01.2023.
//

import Foundation

//["AAPL", "MSFT", "SNAP"]
// [AAPL: Apple Inc.]

final class PersistenceManager {
    static let shared = PersistenceManager()

    private let userDefaults: UserDefaults = .standard

    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }

    private init() {}

    // MARK: - Public

    public var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefalts()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }

    public func addToWatchlist() {

    }

    public func removeFromWatchList() {

    }

    // MARK: - Private

    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }

    private func setUpDefalts() {
        let map: [String: String] = [
            "AAPL": "Apple Inc",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com Inc.",
            "WORK": "Slack Technologies",
            "FB": "Facebook",
            "NVDA": "Nvidia",
            "NKE": "Nike",
            "PINS": "Pinterest Inc."
        ]

        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: Constants.watchListKey)

        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
