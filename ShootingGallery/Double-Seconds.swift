//
//  Double-Seconds.swift
//  ShootingGallery
//
//  Created by Andres camilo Raigoza misas on 10/12/22.
//

import Foundation

extension Int {
    func asTimeFormatted() -> String {
        let seconds = self / 100
        let tensOfMilliSeconds = self % 100
        let formatted = String(format: "%02d:%02d", seconds, tensOfMilliSeconds)
        return formatted
    }
}
