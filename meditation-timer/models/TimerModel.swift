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
		stopTimer()
		remainingDurationSeconds = initialDurationSeconds
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  _ in
			if self.remainingDurationSeconds > 0 {
				self.remainingDurationSeconds -= 1

				// This is published specifically for the ProgressIndicator view. Kinda weird to have it in the model
				self.timerProgress = CGFloat(self.remainingDurationSeconds) / CGFloat(self.initialDurationSeconds)
			} else {
				self.stopTimer()
				WeeklyMeditations.shared.addSession(duration: TimeInterval(self.initialDurationSeconds))
			}
		}

		isRunning = true
		shouldDisableIdleTimer = true
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil

		isRunning = false
		shouldDisableIdleTimer = false

		remainingDurationSeconds = initialDurationSeconds
		timerProgress = 0
	}
	
	func incrementTime() {
		let inMins = initialDurationSeconds / 60

		switch inMins {
			case 3:
				initialDurationSeconds = 5 * 60
			case 4..<30:
				initialDurationSeconds += 5 * 60
			case 30..<60:
				initialDurationSeconds += 15 * 60
			default:
				break
		}
	}

	func decrementTime() {
		let inMins = initialDurationSeconds / 60

		switch inMins {
			case 3,5:
				initialDurationSeconds = 3 * 60
			case 6...30:
				initialDurationSeconds -= 5 * 60
			default:
				initialDurationSeconds -= 15 * 60
		}
	}
}
