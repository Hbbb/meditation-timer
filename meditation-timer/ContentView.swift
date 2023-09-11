import SwiftUI
import UIKit

struct ContentView: View {
	@EnvironmentObject var vm: MeditationViewModel

	var warmupTimeRemaining: Int {
		vm.warmupDuration - vm.elapsedTime
	}

	var meditationTimeRemaining: Int {
		vm.meditationDuration - vm.elapsedTime
	}

	var body: some View {
		switch vm.screenState {
			case .setup:
				TimerConfig()
			case .warmup:
				TimerView(timeRemaining: warmupTimeRemaining,
									label: "Warm Up",
									icon: "forward.end.fill",
									duration: vm.warmupDuration,
									onTapPrimary: vm.warmupDidComplete,
									onTapCancel: vm.stopMeditation)
			case .meditate:
				TimerView(timeRemaining: meditationTimeRemaining,
									label: "Meditate",
									icon: "stop.fill",
									duration: vm.meditationDuration,
									onTapPrimary: vm.stopMeditation,
									onTapCancel: vm.stopMeditation)
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
	var onTapPrimary: (() -> Void)
	var onTapCancel: (() -> Void)

	var body: some View {
		VStack {
			HStack(alignment: .top) {
				Image(systemName: "x.circle")
					.font(.system(size: 32))
					.onTapGesture {
						self.onTapCancel()
					}
				Spacer()
				Image(systemName: "ellipsis.circle")
					.font(.system(size: 32))
			}
			.padding(.bottom, 180)
			.padding(.top, 40)
			ZStack {
				VStack {
					Text(timeRemaining.toMMSS())
					Text(label)
				}
				CircularProgressIndicator(duration: Double(duration))
					.frame(width: 275, height: 275)
			}
			.padding(.bottom, 120)
			Image(systemName: icon)
				.font(.system(size: 40))
				.onTapGesture {
					onTapPrimary()
				}
			Spacer()
		}
		.padding(.horizontal, 20)
	}
}


