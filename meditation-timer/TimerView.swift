import SwiftUI

struct TimerView: View {
	@State private var meditationTime: Int = 3 // Tracks the length of the timer a user chooses
	@State private var timerProgress: CGFloat = 0 // Used by the progress indicator
	@State private var remainingTime: Int = 180 // Remaining time in seconds, used to display the time to the user

	@State private var timer: Timer? = nil
	@State private var isRunning: Bool = false

	var body: some View {
		VStack {
			ZStack {
			ProgressIndicator(progress: timerProgress)
				.frame(width: 300, height: 300)

			Text(isRunning ? "\(remainingTime / 60) min \(remainingTime % 60) sec" : "\(meditationTime) min")
				.font(.title)
			}

			HStack {
				// Decrement button
				Button(action: decrementTime, label: {
					Image(systemName: "minus")
						.font(.system(size: 18))
						.frame(width: 32, height: 32)
						.background(Circle().fill(Color.gray.opacity(0.2)))
				})
				.disabled(isRunning)

				Button(action: {
					if isRunning {
						stopTimer()
					} else {
						startTimer()
					}
				}, label: {
					Image(systemName: isRunning ? "pause" : "play")
						.font(.system(size: 24))
						.frame(width: 44, height: 44)
						.background(Circle().fill(Color.gray.opacity(0.2)))
				})

				// Increment button
				Button(action: incrementTime, label: {
					Image(systemName: "plus")
						.font(.system(size: 18))
						.frame(width: 32, height: 32)
						.background(Circle().fill(Color.gray.opacity(0.2)))
				})
				.disabled(isRunning)
			}
			.padding(.horizontal, 20)
		}
	}

	private func startTimer() {
		stopTimer() // Ensure any existing timer is stopped
		remainingTime = meditationTime * 60
		timerProgress = 1 // Setting the initial value for the timer's progress
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if remainingTime > 0 {
				remainingTime -= 1
				timerProgress = CGFloat(remainingTime) / CGFloat(meditationTime * 60)
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
		timerProgress = 0
	}

	private func incrementTime() {
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

	private func decrementTime() {
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


