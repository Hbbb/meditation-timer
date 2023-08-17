//
//  TimerModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import BackgroundTasks
import AVFoundation

class TimerModel: ObservableObject {
	@Published var meditationTime: Int = 3 // Default to 3 minutes
	@Published var remainingTime: Int = 180
	@Published var isRunning: Bool = false
	@Published var timerProgress: CGFloat = 0

	private var timer: Timer?
}

// Timer controls
extension TimerModel {
	func startTimer() {
		stopTimer() // Ensure any existing timer is stopped
		remainingTime = 20 //meditationTime * 60
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  _ in
			if self.remainingTime > 0 {
				self.remainingTime -= 1
				self.timerProgress = CGFloat(self.remainingTime) / CGFloat(self.meditationTime * 60)
			} else {
				self.stopTimer()
			}
		}
		isRunning = true
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil
		isRunning = false
		timerProgress = 0
	}

	func incrementTime() {
		switch meditationTime {
			case 3:
				meditationTime = 5
			case 4..<30:
				meditationTime += 5
			case 30..<60:
				meditationTime += 15
			default:
				break
		}
	}

	func decrementTime() {
		switch meditationTime {
			case 3,5:
				meditationTime = 3
			case 6...30:
				meditationTime -= 5
			default:
				meditationTime -= 15
		}
	}
}

// Background task stuff. This is used to play a sound upon timer completion
extension TimerModel {
	func registerBackgroundTasks() {
		BGTaskScheduler.shared.register(forTaskWithIdentifier: "politicker.meditation-timer.timerFinished", using: nil) { task in
			self.handleBackgroundTask(task: task as! BGProcessingTask)
		}
	}

	private func handleBackgroundTask(task: BGProcessingTask) {
		task.expirationHandler = {
			// Handle the expiration of the task
		}

		// Here you can perform the actions you need to execute when the task is run
		// For example, update the UI, notify the user, etc.
		//		AudioServicesPlaySystemSound(1000)

		playSound()

		task.setTaskCompleted(success: true)
	}

	func scheduleBackgroundTask() {
		// Only schedule bg task if there's an active timer
		if !isRunning {
			return
		}

		let request = BGProcessingTaskRequest(identifier: "politicker.meditation-timer.timerFinished")
		request.requiresNetworkConnectivity = false // Modify as needed
		request.requiresExternalPower = false      // Modify as needed
		request.earliestBeginDate = Date(timeIntervalSinceNow: Double(remainingTime))

		do {
			try BGTaskScheduler.shared.submit(request)
		} catch {
			print("Could not schedule background task: \(error)")
		}
	}
}

extension TimerModel {
	func playSound() {
		print("============> PLAYING AUDIO")
		do {
			let soundURL = Bundle.main.url(forResource: "small_bell", withExtension: "mp3")!
			let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
			audioPlayer.play()
		} catch {
			print("Error playing sound: \(error)")
		}

	}
}
