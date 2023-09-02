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
				.environment(\.managedObjectContext, dataController.container.viewContext)
				.onAppear {
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
					// Start playing silent .wav track which in theory allows us to play audio while the app is backgrounded
					backgroundTask.start()
					break
				case .active:
					backgroundTask.stop()
					break
				default: ()
			}
		}
	}
}
