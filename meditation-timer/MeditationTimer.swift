//
//  meditation_timerApp.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

@main
struct MeditationTimer: App {
	@Environment(\.scenePhase) private var scenePhase
	@StateObject private var timer = TimerModel()
	@StateObject private var dataController = DataController()

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
				.environmentObject(timer)
				.environment(\.managedObjectContext, dataController.container.viewContext)
		}
		.onChange(of: scenePhase) { phase in
			if phase == .background {
				// Schedule the background task
			}
		}
	}
}
