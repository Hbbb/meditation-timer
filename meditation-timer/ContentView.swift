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
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			LinearGradient(
				stops: [
					Gradient.Stop(color: Color(red: 0.96, green: 0.91, blue: 0.83), location: 0.00),
					Gradient.Stop(color: Color(red: 0.51, green: 0.7, blue: 0.91), location: 1.00),
				],
				startPoint: UnitPoint(x: 0.5, y: 0),
				endPoint: UnitPoint(x: 0.5, y: 1)
			)

			// DARK MODE GRADIENT
//		.background(
//			LinearGradient(
//				stops: [
//					Gradient.Stop(color: Color(red: 0.21, green: 0.31, blue: 0.44), location: 0.00),
//					Gradient.Stop(color: Color(red: 0.43, green: 0.35, blue: 0.48), location: 0.48),
//					Gradient.Stop(color: Color(red: 0.92, green: 0.67, blue: 0.55), location: 1.00),
//				],
//				startPoint: UnitPoint(x: 0.5, y: 0),
//				endPoint: UnitPoint(x: 0.5, y: 1)
//			)
		)
		// This is a hack I use to find real names of fonts. Don't even ask.
		// It prints the names of all custom fonts to the console.
//						.onAppear {
//							for family: String in UIFont.familyNames
//							{
//								print(family)
//								for names: String in UIFont.fontNames(forFamilyName: family)
//								{
//									print("== \(names)")
//								}
//							}
//						}
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
				VStack {
					Text(timeRemaining.toMMSS())
						.font(.custom("SmoochSans-Medium", size: 90))
						.foregroundStyle(AppColors.background)

					Text("Warmup")
						.font(.custom("Barlow-Bold", size: 18))
						.foregroundStyle(AppColors.background)
				}
			}

			Spacer()

			Text("Cancel")
				.onTapGesture {
					onTapCancel()
				}
		}
		.padding(.vertical)
	}
}

#Preview {
	TimerView(timeRemaining: 458, label: "Warmup", icon: "stop.fill", duration: 600, onTapPrimary: {}, onTapCancel: {})
}


