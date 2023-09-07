//
//  TimerManager.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/5/23.
//

import Combine
import Foundation
import UIKit

class TimerManager {
	enum TimerState {
		case idle, running, completed
	}

	private var duration: Int = 0

	var currentTime = CurrentValueSubject<Int, Never>(0)
	var timerState = CurrentValueSubject<TimerState, Never>(.idle)
	private var cancellableSet: Set<AnyCancellable> = []
	private var timer: Timer?
	private var backgroundDate: Date?

	init() {
		setupBackgroundNotificationObservers()
	}

	func startTimer(duration: Int) {
		stopTimer()

		self.duration = duration
		timerState.send(.running)

		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
			self?.tick()
		}
	}

	func resetTimer() {
		timerState.send(.idle)
		stopTimer()
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil
		currentTime.send(0)
	}

	private func tick() {
		currentTime.value += 1
		if currentTime.value >= duration {
			stopTimer()
			timerState.send(.completed)
		}
	}
}

// MARK: Background state management
extension TimerManager {
	private func setupBackgroundNotificationObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(appWentToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
	}

	@objc private func appWentToBackground() {
		backgroundDate = Date()
	}

	@objc private func appCameToForeground() {
		guard let backgroundDate = backgroundDate else { return }

		if timerState.value == .idle {
			return
		}

		let timePassed = Int(Date().timeIntervalSince(backgroundDate))
		currentTime.value = min(timePassed + currentTime.value, duration)

		if timePassed >= duration {
			timerState.send(.completed)
		}

		self.backgroundDate = nil
	}
}
