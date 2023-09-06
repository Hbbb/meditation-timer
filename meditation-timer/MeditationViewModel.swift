//
//  MeditationViewModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/6/23.
//

import Combine
import Foundation

class MeditationViewModel: ObservableObject {
	enum ScreenState {
		case setup, warmup, meditate
	}

	let timerManager: TimerManager = TimerManager()
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
	}

	func startMeditation() {
		if warmupDuration > 0 {
			screenState = .warmup
			timerManager.startTimer(duration: warmupDuration)
		} else {
			screenState = .meditate
			timerManager.startTimer(duration: meditationDuration)
		}
	}

	func stopMeditation() {
		timerManager.resetTimer()
		screenState = .setup
	}

	func completeWarmup() {
		screenState = .meditate
		timerManager.startTimer(duration: meditationDuration)
	}

	func handleState(_ state: TimerManager.TimerState) {
		switch state {
			case .idle:
				screenState = .setup
			case .running: ()
			case .completed:
				if screenState == .warmup {
					completeWarmup()
				}
		}
	}
}

