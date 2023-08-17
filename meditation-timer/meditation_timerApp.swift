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
	@StateObject private var timerModel = TimerModel()

//	init() {
//		timerModel.registerBackgroundTasks()
//	}

	var body: some Scene {
		WindowGroup {
			TimerView()
				.environmentObject(timerModel)
		}
//		.onChange(of: scenePhase) { newScenePhase in
//			switch newScenePhase {
//				case .background:
//					print("========> BACKGROUND: scheduling background task")
//					timerModel.scheduleBackgroundTask()
//				case .active:
//					print("========> ACTIVE: idk if we need to do anything here")
//				default:
//					break
//			}
//		}
	}
}
