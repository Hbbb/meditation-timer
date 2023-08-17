//
//  TimerModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import Foundation

class TimerModel: ObservableObject {
	@Published var meditationTime: Int = 3 // Default to 3 minutes
	@Published var remainingTime: Int = 180
	@Published var isRunning: Bool = false
	@Published var timerProgress: CGFloat = 0

	// This prevents the phone from auto-locking while a timer is running
	@Published var shouldDisableIdleTimer = false

	private var timer: Timer?

	func startTimer() {
		stopTimer() // Ensure any existing timer is stopped
		remainingTime = meditationTime * 60
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  _ in
			if self.remainingTime > 0 {
				self.remainingTime -= 1
				self.timerProgress = CGFloat(self.remainingTime) / CGFloat(self.meditationTime * 60)
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
		switch meditationTime {
			case 3:
				meditationTime = 5
			case 4..<30:
				meditationTime += 5
			case 30..<60:
				meditationTime += 15
			default:
				break
		}
	}

	func decrementTime() {
		switch meditationTime {
			case 3,5:
				meditationTime = 3
			case 6...30:
				meditationTime -= 5
			default:
				meditationTime -= 15
		}
	}
}
