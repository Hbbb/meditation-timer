//
//  meditation_timerApp.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI
import MediaPlayer

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
		}
		.onChange(of: scenePhase) { phase in
			switch(phase) {
				case .background:

					/**
					 If there is an active timer:
					 - Play silent .wav track which enables us to play a sound when the timer ends, even if the app is not in the foreground
					 */
					if vm.screenState == .meditate || vm.screenState == .warmup {
						backgroundTask.start()
					}
					UIApplication.shared.beginReceivingRemoteControlEvents()
					vm.soundManager.setupRemoteTransportControls()
				case .active:
					backgroundTask.stop()
					UIApplication.shared.endReceivingRemoteControlEvents()
				default: ()
			}
		}
	}
}
