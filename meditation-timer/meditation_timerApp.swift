//
//  meditation_timerApp.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI
import BackgroundTasks

@main
struct MeditationTimerApp: App {
	@Environment(\.scenePhase) private var scenePhase
	@StateObject private var timerModel = TimerModel()

	init() {
		BGTaskScheduler.shared.register(
			forTaskWithIdentifier: "com.yourapp.task",
			using: nil
		) { task in
			// Play sound for finished meditation.
			// Will need to pull the timer duration somehow
		}
	}

	var body: some Scene {
		WindowGroup {
			TimerView()
				.environmentObject(timerModel)
		}
		.onChange(of: scenePhase) { phase in
			if phase == .background {
				// Schedule the background task
			}
		}
	}
}
