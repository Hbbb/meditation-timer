//
//  AppViewModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import Foundation

final class AppViewModel: ObservableObject {
	@Published var timerIsRunning: Bool = false

	// Timer defaults to 5 minutes
	@Published var timerDuration: Int = 300 {
		didSet {
			timeRemaining = self.timerDuration
		}
	}

	@Published var timeRemaining: Int = 300

	// Warmup defaults to nothing
	@Published var warmupDuration: Int = 0
	@Published var warmupTimeRemaining: Int = 0

	// The percentage of time left on the timer
	@Published var timerProgress: Double = 1

	var timerDidComplete: (() -> Void)?
	private var timer: Timer?
}

// MARK: Timer controls
extension AppViewModel {
	func startTimer() {
		if timerIsRunning {
			return
		}

		timerIsRunning = true

		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if self.timeRemaining == 0 {
				self.timerDidComplete?()
				self.stopTimer()
			}

			self.timeRemaining -= 1
			self.timerProgress = Double(self.timeRemaining) / Double(self.timerDuration)
		}
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil

		timeRemaining = timerDuration
		timerProgress = 1
		timerIsRunning = false
	}

	// Inc/Dec
	func addTime() {
		timerDuration += 300
	}

	func removeTime() {
		if timerDuration == 300 {
			return
		}

		timerDuration -= 300
	}

	func addWarmupTime() {
		warmupDuration += 30
	}

	func removeWarmupTime() {
		if warmupDuration == 0 {
			return
		}

		warmupDuration -= 30
	}
}

// MARK: Persistence
extension AppViewModel {
	func saveMeditation() {}
}
