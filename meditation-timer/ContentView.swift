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
		ZStack {
			AppColors.background
				.ignoresSafeArea()

			switch vm.screenState {
				case .onboard:
					WelcomeScreen()
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
				case .complete:
					CompletedMeditation {
						HealthKitManager.shared.writeMindfulMinutes(seconds: vm.meditationDuration) { succeeded, err in }
						vm.screenState = .setup
						vm.stopSound()
					}
			}
		}
		// This is a hack I use to find real names of fonts. Don't even ask.
		// It prints the names of all custom fonts to the console.
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

	// TODO: Remove me. There's only a cancel button now, no skip
	var onTapPrimary: (() -> Void)
	var onTapCancel: (() -> Void)

	var body: some View {
		VStack {
			Spacer()

			ZStack {
				ProgressCircle()
				Text(timeRemaining.toMMSS())
					.font(.custom("Barlow-Bold", size: 24))
					.foregroundStyle(.white)
			}

			Spacer()

			PrimaryActionButton(text: "Stop", onTap: onTapCancel)
		}
		.padding(.horizontal)
		.padding(.vertical)
	}
}

#Preview {
	TimerView(timeRemaining: 458, label: "Warmup", icon: "stop.fill", duration: 600, onTapPrimary: {}, onTapCancel: {})
}


