//
//  AppViewModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import Foundation

final class AppViewModel: ObservableObject {
	@Published var timerIsRunning: Bool = false
	@Published var warmupTimerIsRunning: Bool = false

	var meditationIsActive: Bool {
		return warmupTimerIsRunning || timerIsRunning
	}

	// Timer defaults to 5 minutes
	@Published var timerDuration: Int = 30 {
		didSet {
			timeRemaining = self.timerDuration
		}
	}
	@Published var timeRemaining: Int = 30

	// Warmup defaults to nothing
	@Published var warmupDuration: Int = 0 {
		didSet {
			warmupTimeRemaining = self.warmupDuration
		}
	}
	@Published var warmupTimeRemaining: Int = 0

	// The percentage of time left on the timer
	@Published var timerProgress: Double = 1

	var timerDidComplete: (() -> Void)?
	var timerDidStart: (() -> Void)?
	private var timer: Timer?

	var warmupDidStart: (() -> Void)?
	var warmupDidComplete: (() -> Void)?
	private var warmupTimer: Timer?
}

// MARK: Warmup controls
extension AppViewModel {
	func startWarmupTimer() {
		if warmupTimerIsRunning {
			return
		}
		warmupTimerIsRunning = true

		warmupTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if self.warmupTimeRemaining == 0 {
				self.warmupDidComplete?()
				self.stopWarmupTimer()
				return
			}

			self.warmupTimeRemaining -= 1
		}
	}

	func stopWarmupTimer() {
		warmupTimer?.invalidate()
		warmupTimer = nil

		warmupTimeRemaining = warmupDuration

		warmupDidComplete = nil
		warmupTimerIsRunning = false
	}
}

// MARK: Timer controls
extension AppViewModel {
	func startMeditation() {
		if warmupDuration > 0 {
			Logger.info("Starting warmup", context: .viewModel)
			startWarmupTimer()

			self.warmupDidComplete = {
				Logger.info("Warmup complete", context: .viewModel)
				self.startTimer()
			}
		}
	}

	func startTimer() {
		if timerIsRunning {
			return
		}
		timerIsRunning = true

		self.timerDidStart?()

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
