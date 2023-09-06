//
//  AppViewModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import Foundation

/**
 * Controls the state of the view
 */
enum ViewState {
	case config, warmup, meditation
}

final class AppViewModel: ObservableObject {
	@Published var viewState: ViewState = .meditation

	// Timer defaults to 1 minutes
	@Published var timerDuration: Int = 60 {
		didSet {
			timeRemaining = self.timerDuration
		}
	}
	@Published var timeRemaining: Int = 60

	// Warmup defaults to nothing
	@Published var warmupDuration: Int = 0 {
		didSet {
			warmupTimeRemaining = self.warmupDuration
		}
	}
	@Published var warmupTimeRemaining: Int = 0

	// The percentage of time left on the timer
	@Published var timerProgress: Double = 1
	@Published var warmupProgress: Double = 1

	var timerDidComplete: (() -> Void)?
	var timerDidStart: (() -> Void)?
	private var timer: Timer?

	var warmupDidStart: (() -> Void)?
	var warmupDidComplete: (() -> Void)?
	private var warmupTimer: Timer?

	var didGoToBackgroundAt: Date?
}

// MARK: Warmup controls
extension AppViewModel {
	func startWarmupTimer() {
		if viewState == .warmup {
			return
		}
		viewState = .warmup

		warmupTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if self.warmupTimeRemaining == 0 {
				self.warmupDidComplete?()
				self.stopWarmupTimer()
				return
			}

			self.warmupTimeRemaining -= 1
			self.warmupProgress = Double(self.warmupTimeRemaining) / Double(self.warmupDuration)
		}
	}

	func stopWarmupTimer() {
		warmupTimer?.invalidate()
		warmupTimer = nil

		warmupTimeRemaining = warmupDuration
		warmupProgress = 1
		warmupDidComplete = nil
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

			return
		}

		startTimer()
	}

	func startTimer() {
		if viewState == .meditation {
			return
		}
		viewState = .meditation

		DispatchQueue.global(qos: .userInteractive).async {
			Logger.info("timerDidStart()", context: .viewModel)
			self.timerDidStart?()
		}

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
		viewState = .config
	}
}

// MARK: Persistence
extension AppViewModel {
	func saveMeditation() {}
}
