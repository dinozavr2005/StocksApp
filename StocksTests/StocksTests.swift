//
//  StocksTests.swift
//  StocksTests
//
//  Created by Buikliskii Vladimir on 05.04.2023.
//

@testable import Stocks

import XCTest

final class StocksTests: XCTestCase {

    func testCandleStickDataConversion() {
        let doubles: [Double] = Array(repeating: 12.2, count: 10)
        var timestamps: [TimeInterval] = Array(repeating: Date().timeIntervalSince1970, count: 12)
        for x in 0..<12 {
            let interval = Date().addingTimeInterval(3600 * TimeInterval(x)).timeIntervalSince1970
            timestamps.append(interval)
        }
        timestamps.shuffle()

        let marketData = MarketDataResponse(open: doubles, close: doubles, high: doubles, low: doubles, status: "Success", timestamps: timestamps)
        let candleSticks = marketData.candleSticks
        XCTAssertEqual(candleSticks.count, marketData.open.count)
        XCTAssertEqual(candleSticks.count, marketData.close.count)
        XCTAssertEqual(candleSticks.count, marketData.high.count)
        XCTAssertEqual(candleSticks.count, marketData.low.count)
    }

}
