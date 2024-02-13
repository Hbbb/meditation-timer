//
//  MeditationViewModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/6/23.
//

import Combine
import Foundation
import SwiftUI

extension Logger {
	fileprivate static func info(_ message: String) {
		Logger.info(message, context: .viewModel)
	}
}

class MeditationViewModel: ObservableObject {
	enum ScreenState {
		case onboard, setup, warmup, meditate, complete
	}

	let timerManager: TimerManager = TimerManager()
	let soundManager: SoundManager = SoundManager()

	private var cancellableSet: Set<AnyCancellable> = []

	@AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
	@AppStorage("meditationDuration") var savedMeditationDuration: Int = 600
	@AppStorage("warmupDuration") var savedWarmupDuration: Int = 15

	@Published var screenState: ScreenState = .setup
	@Published var elapsedTime: Int = 0
	@Published var warmupDuration: Int = 0
	@Published var meditationDuration: Int = 60

	init() {
		if !hasCompletedOnboarding {
			screenState = .onboard
		}

		timerManager.timerState
			.sink { [weak self] state in
				self?.handleState(state)
			}
			.store(in: &cancellableSet)

		timerManager.currentTime.assign(to: &$elapsedTime)

		meditationDuration = savedMeditationDuration
		warmupDuration = savedWarmupDuration
	}

	func startMeditation() {
		if warmupDuration > 0 {
			screenState = .warmup
			timerManager.startTimer(duration: warmupDuration)
		} else {
			screenState = .meditate
			timerManager.startTimer(duration: meditationDuration)
		}

		saveMeditationPreferences()
		Logger.info("Starting meditation. Warmup: \(warmupDuration) | Meditation:\(meditationDuration)")
	}

	func stopMeditation() {
		timerManager.resetTimer()
		screenState = .setup
		soundManager.stopSound()

		Logger.info("Stopping meditation")
	}

	func warmupDidComplete() {
		screenState = .meditate
		elapsedTime = 0
		timerManager.startTimer(duration: meditationDuration)
	}

	func meditationDidComplete() {
		soundManager.playSound(soundName: "singing-bowl", volume: 100.0)
		screenState = .complete
	}

	func stopSound() {
		soundManager.stopSound()
	}

	func didCompleteOnboarding() {
		hasCompletedOnboarding = true
		screenState = .setup
	}

	func playSound() {
		soundManager.pauseSound()
	}

	func pauseSound() {
		soundManager.pauseSound()
	}

	private func saveMeditationPreferences() {
		savedMeditationDuration = meditationDuration
		savedWarmupDuration = warmupDuration
	}

	private func handleState(_ state: TimerManager.TimerState) {
		Logger.info("Timer State: \(state) | ScreenState: \(screenState)")

		switch state {
			case .idle:
				screenState = hasCompletedOnboarding ? .setup : .onboard
			case .running:
				if screenState == .meditate {
					soundManager.playSound(soundName: "singing-bowl", volume: 100.0)
				}
			case .completed:
				switch screenState {
					case .warmup:
						warmupDidComplete()
					case .meditate:
						meditationDidComplete()
					default: ()
				}
		}
	}
}

