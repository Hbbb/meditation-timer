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

			TimerControlsView()
		}
		.onReceive(timer.$shouldDisableIdleTimer) { _ in
			updateIdleTimer()
		}
	}

	private func updateIdleTimer() {
		UIApplication.shared.isIdleTimerDisabled = timer.shouldDisableIdleTimer
	}
}


