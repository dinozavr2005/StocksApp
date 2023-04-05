//
//  HapticsManager.swift
//  Stocks
//
//  Created by Buikliskii Vladimir on 27.01.2023.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    // MARK: - Public

    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    /// Play haptic for given type interaction
    /// - Parameter type: Type of vibrate for
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
