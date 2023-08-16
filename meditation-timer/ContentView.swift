import SwiftUI

struct ContentView: View {
	@State private var timer: Timer? = nil
	@State private var secondsRemaining = 180.0 // 3 minutes as the default
	@State private var angle: Double = 0
	@State private var isPaused: Bool = false
	let tickPoints: [Double] = [3, 5, 10, 15, 20, 30, 60]

	var body: some View {
		VStack {
			Text("Meditation Timer")
				.font(.largeTitle)

			CircularDial(angle: $angle)
				.frame(width: 300, height: 300)
				.onChange(of: angle) { newAngle in
					secondsRemaining = angleToSeconds(newAngle)
				}

			if timer == nil {
				Text("\(angleToMinutes(angle), specifier: "%.0f") min")
					.font(.largeTitle)
			} else {
				if secondsRemaining >= 60 {
					Text("\(Int(secondsRemaining / 60)) min \(Int(secondsRemaining.truncatingRemainder(dividingBy: 60))) sec")
						.font(.largeTitle)
				} else {
					Text("\(Int(secondsRemaining)) sec")
						.font(.largeTitle)
				}
			}

			HStack {
				Button("Start") {
					self.isPaused = false
					if self.timer == nil {
						self.secondsRemaining = angleToSeconds(self.angle)
						self.startTimer()
					}
				}

				Button("Pause") {
					self.isPaused.toggle()
				}

				Button("Reset") {
					self.timer?.invalidate()
					self.timer = nil
					self.secondsRemaining = angleToSeconds(self.angle)
				}
			}
			.padding()
		}
	}

	func startTimer() {
		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if !self.isPaused && self.secondsRemaining > 0 {
				self.secondsRemaining -= 1
			} else if self.secondsRemaining <= 0 {
				self.timer?.invalidate()
				self.timer = nil
			}
		}
	}

	func angleToMinutes(_ angle: Double) -> Double {
		let index = Int(angle / (360 / Double(tickPoints.count)))
		return tickPoints[index % tickPoints.count]
	}

	func angleToSeconds(_ angle: Double) -> Double {
		return angleToMinutes(angle) * 60.0
	}
}

