import SwiftUI
import UIKit

struct TimerView: View {
	@EnvironmentObject var timer: TimerModel

	var formattedTime: String {
		let minutes = Int(timer.remainingTime / 60)
		let seconds = Int(timer.remainingTime % 60)
		let secondsFormatted = String(format: "%02d", seconds)

		if timer.isRunning {
			return "\(minutes):\(secondsFormatted)"
		} else {
			return "\(timer.meditationTime):00"
		}
	}

	var body: some View {
		VStack {
			ZStack {
				ProgressIndicator(progress: timer.timerProgress)
					.frame(width: 300, height: 300)

				Text(formattedTime)
					.font(.title)
			}

			HStack {
				// Decrement button
				Button(action: timer.decrementTime, label: {
					Image(systemName: "minus")
						.font(.system(size: 18))
						.frame(width: 32, height: 32)
						.background(Circle().fill(Color.gray.opacity(0.2)))
				})
				.disabled(timer.isRunning)

				// Play/pause button
				Button(action: {
					if timer.isRunning {
						timer.stopTimer()
					} else {
						timer.startTimer()
					}
				}, label: {
					Image(systemName: timer.isRunning ? "pause" : "play")
						.font(.system(size: 24))
						.frame(width: 44, height: 44)
						.background(Circle().fill(Color.gray.opacity(0.2)))
				})

				// Increment button
				Button(action: timer.incrementTime, label: {
					Image(systemName: "plus")
						.font(.system(size: 18))
						.frame(width: 32, height: 32)
						.background(Circle().fill(Color.gray.opacity(0.2)))
				})
				.disabled(timer.isRunning)
			}
		}
		.onReceive(timer.$shouldDisableIdleTimer) { _ in
			updateIdleTimer()
		}
	}

	private func updateIdleTimer() {
		UIApplication.shared.isIdleTimerDisabled = timer.shouldDisableIdleTimer
	}
}


