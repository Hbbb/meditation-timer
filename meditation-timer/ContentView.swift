import SwiftUI
import UIKit

struct ContentView: View {
	@EnvironmentObject var audioManager: AudioManager
	@EnvironmentObject var timer: TimerModel
	@State private var gestureStart: Double = .zero
	@State private var gestureHeight: Double = .zero
	@Environment(\.managedObjectContext) var moc

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
				CircularProgressIndicator(progress: timer.progress)
					.frame(width: 300, height: 300)

				ZStack {
					Circle()
						.fill(Colors.primary)
						.frame(width: 225, height: 225)
					Text(timeRemainingLabel)
						.font(.custom("Varela Round", size: 52))
				}
			}
			PlayPauseButton()
				.padding(.top, 80)
		}
		.onAppear {
			audioManager.start()
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

						gestureStart = value.location.y
					}

					gestureHeight = yOff
				}
				.onEnded { _ in
					gestureHeight = .zero
				}
		)

// This is a hack I use to find real names of fonts. Don't even ask
//		.onAppear {
//			for family: String in UIFont.familyNames
//			{
//				print(family)
//				for names: String in UIFont.fontNames(forFamilyName: family)
//				{
//					print("== \(names)")
//				}
//			}
//		}
	}

	private func updateIdleTimer() {
		UIApplication.shared.isIdleTimerDisabled = timer.shouldDisableIdleTimer
	}
}


