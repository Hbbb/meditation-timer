import SwiftUI
import UIKit

struct ContentView: View {
	@EnvironmentObject var audioManager: AudioManager
	@EnvironmentObject var viewModel: AppViewModel

	@State private var gestureStart: Double = .zero
	@State private var gestureHeight: Double = .zero

	@Environment(\.managedObjectContext) var moc

	var body: some View {
		TimerConfig()
			.sheet(isPresented: $viewModel.timerIsRunning) {
				VStack {
					ZStack {
						CircularProgressIndicator(progress: viewModel.timerProgress)
							.frame(width: 300, height: 300)

						ZStack {
							Circle()
								.fill(Colors.primary)
								.frame(width: 225, height: 225)
							Text(viewModel.timeRemaining.toMMSS())
								.font(.custom("Varela Round", size: 52))
						}
					}

					PlayPauseButton(icon: "stop.circle") {
						viewModel.stopTimer()
					}
					.padding(.vertical)
				}
			}
		//		.onReceive(timer.$shouldDisableIdleTimer) { _ in
		//			updateIdleTimer()
		//		}
		//		.gesture(
		//			DragGesture()
		//				.onChanged { value in
		//					if viewModel.timerIsRunning {
		//						return
		//					}
		//
		//					let yOff = value.translation.height
		//
		//					if gestureStart == .zero {
		//						gestureStart = value.startLocation.y
		//					}
		//
		//					let distance = abs(value.location.y - gestureStart)
		//					if distance >= 30 {
		//						if yOff < gestureHeight {
		//							viewModel.addTime()
		//						} else {
		//							viewModel.removeTime()
		//						}
		//
		//						gestureStart = value.location.y
		//					}
		//
		//					gestureHeight = yOff
		//				}
		//				.onEnded { _ in
		//					gestureHeight = .zero
		//				}
		//		)

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
		UIApplication.shared.isIdleTimerDisabled = true
	}
}


