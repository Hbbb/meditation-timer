import SwiftUI

struct TimerView: View {
	@EnvironmentObject var timer: TimerModel

	var body: some View {
		VStack {
			ZStack {
				ProgressIndicator(progress: timer.timerProgress)
					.frame(width: 300, height: 300)

				Text(timer.isRunning ? "\(timer.remainingTime / 60) min \(timer.remainingTime % 60) sec" : "\(timer.meditationTime) min")
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
			.padding(.horizontal, 40)
		}
	}

}


