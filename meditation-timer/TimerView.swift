import SwiftUI
import UIKit

struct TimerView: View {
	@EnvironmentObject var timer: TimerModel

	var timeRemainingLabel: String {
		let minutes = Int(timer.remainingDurationSeconds / 60)
		let seconds = Int(timer.remainingDurationSeconds % 60)
		let secondsFormatted = String(format: "%02d", seconds)

		if timer.isRunning {
			return "\(minutes):\(secondsFormatted)"
		} else {
			return "\(timer.initialDurationSeconds):00"
		}
	}

	var body: some View {
		VStack {
			ZStack {
				ProgressIndicator(progress: timer.timerProgress)
					.frame(width: 300, height: 300)

				Text(timeRemainingLabel)
					.font(.title)
			}

			TimerControls()
		}
		.onReceive(timer.$shouldDisableIdleTimer) { _ in
			updateIdleTimer()
		}
	}

	private func updateIdleTimer() {
		UIApplication.shared.isIdleTimerDisabled = timer.shouldDisableIdleTimer
	}
}


