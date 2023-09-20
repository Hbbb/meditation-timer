//
//  MeditationViewModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/6/23.
//

import Combine
import Foundation

extension Logger {
	fileprivate static func info(_ message: String) {
		Logger.info(message, context: .viewModel)
	}
}

class MeditationViewModel: ObservableObject {
	enum ScreenState {
		case setup, warmup, meditate, complete
	}

	let timerManager: TimerManager = TimerManager()
	let soundManager: SoundManager = SoundManager()

	let durationDefaultsKey = "meditationDuration"
	let warmupDurationDefaultsKey = "warmupDuration"

	private var cancellableSet: Set<AnyCancellable> = []

	@Published var screenState: ScreenState = .setup
	@Published var elapsedTime: Int = 0
	@Published var warmupDuration: Int = 0
	@Published var meditationDuration: Int = 60

	init() {
		timerManager.timerState
			.sink { [weak self] state in
				self?.handleState(state)
			}
			.store(in: &cancellableSet)

		timerManager.currentTime.assign(to: &$elapsedTime)

		if let savedMeditationDuration = UserDefaults.standard.value(forKey: self.durationDefaultsKey) as? Int,
			 let savedWarmupDuration = UserDefaults.standard.value(forKey: self.warmupDurationDefaultsKey) as? Int {
			meditationDuration = savedMeditationDuration
			warmupDuration = savedWarmupDuration
		}
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
		timerManager.startTimer(duration: meditationDuration)
	}

	func meditationDidComplete() {
		soundManager.playSound(soundName: "singing-bowl", volume: 100.0)
		screenState = .complete
	}

	private func saveMeditationPreferences() {
		UserDefaults.standard.set(meditationDuration, forKey: self.durationDefaultsKey)
		UserDefaults.standard.set(warmupDuration, forKey: self.warmupDurationDefaultsKey)
	}

	private func handleState(_ state: TimerManager.TimerState) {
		Logger.info("Timer State: \(state) | ScreenState: \(screenState)")

		switch state {
			case .idle:
				screenState = .setup
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

