import SwiftUI
import UIKit

struct ContentView: View {
	@EnvironmentObject var vm: MeditationViewModel

	@Environment(\.managedObjectContext) var moc

	var body: some View {
		switch vm.screenState {
			case .setup:
				TimerConfig()
			case .warmup:
				TimerView(timeRemaining: vm.warmupDuration - vm.elapsedTime,
									label: "Warm Up",
									icon: "forward.end.fill",
									duration: vm.warmupDuration,
									onTap: vm.completeWarmup)
			case .meditate:
				TimerView(timeRemaining: vm.meditationDuration - vm.elapsedTime,
									label: "Meditate",
									icon: "stop.fill",
									duration: vm.meditationDuration,
									onTap: vm.stopMeditation)
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
	var duration: Int
	var onTap: (() -> Void)

	var body: some View {
		VStack {
			ZStack {
				VStack {
					Text(timeRemaining.toMMSS())
					Text(label)
				}
				CircularProgressIndicator(duration: Double(duration))
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


