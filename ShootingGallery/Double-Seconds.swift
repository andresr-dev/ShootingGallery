//
//  Double-Seconds.swift
//  ShootingGallery
//
//  Created by Andres camilo Raigoza misas on 10/12/22.
//

import Foundation

extension Double {
    func asTimeFormatted() -> String {
        let seconds = (self / 100).rounded()
        let tensOfMilliseconds = self.truncatingRemainder(dividingBy: 100)
        let formatted = String(format: "%02.0f:%02.0f", seconds, tensOfMilliseconds)
        return formatted
    }
}
