//
//  TimerModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import Foundation

let THREE_MINUTES = 3 * 60
let FIVE_MINUTES = 5 * 60
let FIFTEEN_MINUTES = 15 * 60

class TimerModel: ObservableObject {
	@Published var initialDurationSeconds: Int = 180 // The user-selected duration. Defaults to 3 minutes
	@Published var remainingDurationSeconds: Int = 180 // The duration that the timer works against

	@Published var isRunning: Bool = false
	@Published var progress: Double = 0

	// Prevents phone from auto-locking while a timer is running
	@Published var shouldDisableIdleTimer = false

	private var timer: Timer?

	func start() {
		stop()
		remainingDurationSeconds = initialDurationSeconds
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  _ in
			guard self.remainingDurationSeconds > 0 else {
				self.stop()
				return
			}

			self.remainingDurationSeconds -= 1

			// This is published specifically for the ProgressIndicator view. Kinda weird to have it in the model
			self.progress = Double(self.remainingDurationSeconds / self.initialDurationSeconds)

			self.isRunning = true
			self.shouldDisableIdleTimer = true
		}
	}

	func stop() {
		timer?.invalidate()
		timer = nil

		isRunning = false
		shouldDisableIdleTimer = false

		remainingDurationSeconds = initialDurationSeconds
		progress = 0
	}
	
	func incrementTime() {
		let inMins = initialDurationSeconds / 60

		switch inMins {
			case 3:
				initialDurationSeconds = FIVE_MINUTES
			case 4..<30:
				initialDurationSeconds += FIVE_MINUTES
			case 30..<60:
				initialDurationSeconds += FIFTEEN_MINUTES
			default:
				break
		}
	}

	func decrementTime() {
		let inMins = initialDurationSeconds / 60

		switch inMins {
			case 3,5:
				initialDurationSeconds = THREE_MINUTES
			case 6...30:
				initialDurationSeconds -= FIVE_MINUTES
			default:
				initialDurationSeconds -= FIFTEEN_MINUTES
		}
	}
}
