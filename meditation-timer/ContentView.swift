import SwiftUI
import UIKit

struct ContentView: View {
	@EnvironmentObject var audioManager: AudioManager
	@EnvironmentObject var viewModel: AppViewModel

	@State private var gestureStart: Double = .zero
	@State private var gestureHeight: Double = .zero

	@Environment(\.managedObjectContext) var moc

	var body: some View {
		switch viewModel.viewState {
			case .config:
				TimerConfig()
			case .warmup:
				TimerView(timeRemaining: viewModel.warmupTimeRemaining,
									label: "Warm Up",
									icon: "forward.end.fill",
									progress: viewModel.warmupProgress,
									onTap: {
					viewModel.stopWarmupTimer()
					viewModel.startTimer()
				})
			case .meditation:
				TimerView(timeRemaining: viewModel.timeRemaining,
									label: "Meditate",
									icon: "stop.fill",
									progress: viewModel.timerProgress,
									onTap: viewModel.stopTimer)
		}
		// This is a hack I use to find real names of fonts. Don't even ask
		//				.onAppear {
		//					for family: String in UIFont.familyNames
		//					{
		//						print(family)
		//						for names: String in UIFont.fontNames(forFamilyName: family)
		//						{
		//							print("== \(names)")
		//						}
		//					}
		//				}
	}
}

struct TimerView: View {
	var timeRemaining: Int
	var label: String
	var icon: String
	var progress: Double
	var onTap: (() -> Void)

	var body: some View {
		VStack {
			ZStack {
				VStack {
					Text(timeRemaining.toMMSS())
					Text(label)
				}
				CircularProgressIndicator(progress: progress)
					.frame(width: 225, height: 225)
			}
			.padding(.bottom, 120)
			Image(systemName: icon)
				.font(.system(size: 40))
				.onTapGesture {
					onTap()
				}
		}
	}
}


