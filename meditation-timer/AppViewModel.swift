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
	@Published var timerDuration: Int = 30
	@Published var timeRemaining: Int = 30

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
	}

	// Inc/Dec
	func addTime() {
		timerDuration += 5
	}

	func removeTime() {
		if timerDuration == 5 {
			return
		}

		timerDuration -= 5
	}
}

// MARK: Persistence
extension AppViewModel {
	func saveMeditation() {}
}
