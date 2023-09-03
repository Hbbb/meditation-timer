//
//  Int+TimeFormatting.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/3/23.
//

import Foundation

extension Int {
	func toMMSS() -> String {
		let minutes = self / 60
		let seconds = self % 60
		let minutesFormatted = String(format: "%02d", minutes)
		let secondsFormatted = String(format: "%02d", seconds)
		return "\(minutesFormatted):\(secondsFormatted)"
	}
}
