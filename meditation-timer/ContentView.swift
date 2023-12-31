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

struct TopControls: View {
	var onTap: (() -> Void)

	var body: some View {
		HStack(alignment: .top) {
			Image(systemName: "x.circle")
				.font(.system(size: 32))
				.onTapGesture {
					self.onTap()
				}
			Spacer()
			Image(systemName: "ellipsis.circle")
				.font(.system(size: 32))
		}
	}
}

struct Progress: View {
	var timeRemaining: Int
	var label: String
	var duration: Int

	var body: some View {
		ZStack {
			VStack {
				Text(timeRemaining.toMMSS())
					.font(.custom("Barlow-Bold", size: 24))
				Text(label)
					.font(.custom("Barlow-Regular", size: 16))
			}
			CircularProgressIndicator(duration: Double(duration))
				.frame(width: 275, height: 275)
		}
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
			TopControls(onTap: onTapCancel)
				.padding(.bottom, 120)
				.padding(.top, 40)

			Progress(timeRemaining: timeRemaining, label: label, duration: duration)
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

#Preview {
	TimerView(timeRemaining: 458, label: "Warmup", icon: "", duration: 600, onTapPrimary: {}, onTapCancel: {})
}


