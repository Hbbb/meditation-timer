//
//  TimerModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import Foundation

class TimerModel: ObservableObject {
	@Published var initialDurationSeconds: Int = 180 // The user-selected duration. Defaults to 3 minutes
	@Published var remainingDurationSeconds: Int = 180 // The duration that the timer works against

	@Published var isRunning: Bool = false
	@Published var timerProgress: CGFloat = 0

	// Prevents phone from auto-locking while a timer is running
	@Published var shouldDisableIdleTimer = false

	private var timer: Timer?

	func startTimer() {
		stopTimer() // Ensure any existing timer is stopped
		remainingDurationSeconds = initialDurationSeconds
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  _ in
			if self.remainingDurationSeconds > 0 {
				self.remainingDurationSeconds -= 1
				self.timerProgress = CGFloat(self.remainingDurationSeconds) / CGFloat(self.initialDurationSeconds)
			} else {
				self.stopTimer()
			}
		}
		isRunning = true

		shouldDisableIdleTimer = true
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil
		isRunning = false
		timerProgress = 0
		shouldDisableIdleTimer = false
	}
	
	func incrementTime() {
		let inMins = initialDurationSeconds * 60

		switch inMins {
			case 3:
				initialDurationSeconds = 5
			case 4..<30:
				initialDurationSeconds += 5
			case 30..<60:
				initialDurationSeconds += 15
			default:
				break
		}
	}

	func decrementTime() {
		let inMins = initialDurationSeconds * 60

		switch inMins {
			case 3,5:
				initialDurationSeconds = 3
			case 6...30:
				initialDurationSeconds -= 5
			default:
				initialDurationSeconds -= 15
		}
	}
}
