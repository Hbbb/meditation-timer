import SwiftUI

struct TimerView: View {
	@State private var meditationTime: Int = 3 // Starting time in minutes
	@State private var remainingTime: Int = 180 // Remaining time in seconds
	@State private var timer: Timer? = nil
	@State private var isRunning: Bool = false

	var progress: CGFloat {
		if remainingTime == meditationTime * 60 || remainingTime == 0 {
			return 1
		}
		return CGFloat(remainingTime) / CGFloat(meditationTime * 60)
	}

	var body: some View {
		VStack {
			ProgressIndicator(progress: progress)
				.frame(width: 300, height: 300)

			Text("\(remainingTime / 60) min \(remainingTime % 60) sec")
				.font(.title)

			HStack {
				// Decrement button
				Button(action: decrementTime, label: {
					Image(systemName: "minus")
				})

				// Increment button
				Button(action: incrementTime, label: {
					Image(systemName: "plus")
				})
			}

			Button(action: {
				if isRunning {
					stopTimer()
				} else {
					startTimer()
				}
			}, label: {
				Text(isRunning ? "Stop" : "Start")
					.padding()
					.background(isRunning ? Color.red : Color.green)
					.foregroundColor(.white)
					.cornerRadius(10)
			})
		}
		.onDisappear {
			// Stop the timer when the view disappears
			stopTimer()
		}
	}

	private func startTimer() {
		stopTimer() // Ensure any existing timer is stopped
		remainingTime = meditationTime * 60
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if remainingTime > 0 {
				remainingTime -= 1
			} else {
				stopTimer()
			}
		}
		isRunning = true
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
		isRunning = false
	}

	private func incrementTime() {
		if meditationTime == 3 {
			meditationTime = 5
		} else if meditationTime < 30 {
			meditationTime += 5
		} else if meditationTime < 60 {
			meditationTime += 15
		}
	}

	private func decrementTime() {
		if meditationTime == 5 {
			meditationTime = 3
		} else if meditationTime <= 30 {
			meditationTime -= 5
		} else {
			meditationTime -= 15
		}
	}
}


