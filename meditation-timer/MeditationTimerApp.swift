//
//  meditation_timerApp.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

@main
struct MeditationTimerApp: App {
	@Environment(\.scenePhase) private var scenePhase

	@StateObject private var viewModel = AppViewModel()
	@StateObject private var dataController = DataController()
	@StateObject private var alarmPlayer = AlarmPlayer()
	@StateObject private var vm = MeditationViewModel()

	private var backgroundTask = BackgroundTask()

	//	init() {
	//		BGTaskScheduler.shared.register(
	//			forTaskWithIdentifier: "com.yourapp.task",
	//			using: nil
	//		) { task in
	//			// Play sound for finished meditation.
	//			// Will need to pull the timer duration somehow
	//		}
	//	}

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(backgroundTask)
				.environmentObject(alarmPlayer)
				.environmentObject(viewModel)
				.environmentObject(vm)
				.environment(\.managedObjectContext, dataController.container.viewContext)
				.onAppear {
					viewModel.timerDidStart = {
						alarmPlayer.playSound(soundName: "singing-bowl", volume: 100.0)

						// TODO: This is a temporary hack. Once I get a proper track I won't need to cut this off
						Thread.sleep(forTimeInterval: 5.0)
						alarmPlayer.stopSound()
					}

					viewModel.timerDidComplete = {
						alarmPlayer.playSound(soundName: "singing-bowl", volume: 100.0)

						// TODO: This is a temporary hack. Once I get a proper track I won't need to cut this off
						Thread.sleep(forTimeInterval: 5.0)
						alarmPlayer.stopSound()

						// Stop playing silent track after timer completes. The next time a user
						// opens the app to start a new timer, the backgroundTask will resume
						backgroundTask.stop()
					}
				}
		}
		.onChange(of: scenePhase) { phase in
			switch(phase) {
				case .background:

					/**
					 If there is an active timer:
					 - Play silent .wav track which enables us to play a sound when the timer ends, even if the app is not in the foreground
					 - Capture the time the user went to the background. This is used to compute the time difference when they re-open the app
					 */
					if viewModel.viewState != .config {
						backgroundTask.start()
						viewModel.didGoToBackgroundAt = .now
					}
				case .active:
					backgroundTask.stop()

					// If there's not an active timer running, no need to handle this
					if viewModel.viewState == .config {
						return
					}

					if let backroundAt = viewModel.didGoToBackgroundAt {
						viewModel.didGoToBackgroundAt = nil

						let elapsedSeconds = Int(Date().timeIntervalSince(backroundAt))

						// The timer is expired, take them back to the config screen
						if elapsedSeconds > viewModel.timeRemaining {
							viewModel.viewState = .config
						} else {
							viewModel.timeRemaining = viewModel.timeRemaining - elapsedSeconds
						}
					}

				default: ()
			}
		}
	}
}
