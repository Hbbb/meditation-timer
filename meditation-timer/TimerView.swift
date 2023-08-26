import SwiftUI
import UIKit

struct TimerView: View {
	@EnvironmentObject var timer: TimerModel
	@State private var gestureStart: Double = .zero
	@State private var gestureHeight: Double = .zero

	var timeRemainingLabel: String {
		let minutes = Int(timer.remainingDurationSeconds / 60)
		let seconds = Int(timer.remainingDurationSeconds % 60)
		let secondsFormatted = String(format: "%02d", seconds)

		if timer.isRunning {
			return "\(minutes):\(secondsFormatted)"
		} else {
			return "\(timer.initialDurationSeconds / 60):00"
		}
	}

	var body: some View {
		VStack {
			ZStack {
				CircularProgressIndicator(progress: timer.timerProgress)
					.frame(width: 300, height: 300)
					.animation(.easeInOut, value: timer.timerProgress)

				ZStack {
					Circle()
						.fill(Colors.primary)
						.frame(width: 225, height: 225)
					Text(timeRemainingLabel)
						.font(.title)
				}
			}

			TimerControls()
				.padding(.top, 80)
		}
		.onReceive(timer.$shouldDisableIdleTimer) { _ in
			updateIdleTimer()
		}
		.gesture(
			DragGesture()
				.onChanged { value in
					if timer.isRunning {
						return
					}

					let yOff = value.translation.height

					if gestureStart == .zero {
						gestureStart = value.startLocation.y
					}

					let distance = abs(value.location.y - gestureStart)
					if distance >= 30 {
						if yOff < gestureHeight {
							timer.incrementTime()
						} else {
							timer.decrementTime()
						}

						UIImpactFeedbackGenerator(style: .light).impactOccurred()
						gestureStart = value.location.y
					}

					gestureHeight = yOff
				}
				.onEnded { _ in
					gestureHeight = .zero
				}
		)
	}

	private func updateIdleTimer() {
		UIApplication.shared.isIdleTimerDisabled = timer.shouldDisableIdleTimer
	}
}


