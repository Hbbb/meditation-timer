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

	@StateObject private var dataController = DataController()
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
				.environmentObject(vm)
				.environment(\.managedObjectContext, dataController.container.viewContext)
				.onAppear {
					HealthKitManager.shared.requestHealthKitPermission() { succeeded, err in
						print("health kit permissions requested")
					}
				}
		}
		.onChange(of: scenePhase) { phase in
			switch(phase) {
				case .background:

					/**
					 If there is an active timer:
					 - Play silent .wav track which enables us to play a sound when the timer ends, even if the app is not in the foreground
					 */
					if vm.screenState != .setup {
						backgroundTask.start()
					}
				case .active:
					backgroundTask.stop()
				default: ()
			}
		}
	}
}
