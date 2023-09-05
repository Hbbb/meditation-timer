import SwiftUI
import UIKit

struct ContentView: View {
	@EnvironmentObject var audioManager: AudioManager
	@EnvironmentObject var viewModel: AppViewModel

	@State private var gestureStart: Double = .zero
	@State private var gestureHeight: Double = .zero

	@Environment(\.managedObjectContext) var moc

	var body: some View {
		switch viewModel.timerState {
			case .config:
				TimerConfig()
			case .warmup:
				VStack {
					ZStack {
						VStack {
							Text("-\(viewModel.warmupTimeRemaining.toMMSS())")
							Text("Warm Up")
						}
						CircularProgressIndicator(progress: viewModel.warmupProgress)
							.frame(width: 225, height: 225)
					}
					.padding(.bottom, 120)
					Image(systemName: "forward.end.fill")
						.font(.system(size: 40))
				}
			case .meditation:
				VStack {
					ZStack {
						VStack {
							Text(viewModel.timeRemaining.toMMSS())
							Text("Meditation")
						}
						CircularProgressIndicator(progress: viewModel.timerProgress)
							.frame(width: 225, height: 225)
					}
					.padding(.bottom, 120)
					Image(systemName: "stop.fill")
						.font(.system(size: 40))
				}
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


