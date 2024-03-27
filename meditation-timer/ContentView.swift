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
		NavigationView {
			ZStack {
				switch vm.screenState {
					case .onboard:
						WelcomeScreen()
					case .setup:
						TimerConfig()
					case .warmup:
						TimerView(timeRemaining: warmupTimeRemaining,
											label: "Warmup",
											duration: vm.warmupDuration,
											onActionTap: vm.stopMeditation)
					case .meditate:
						TimerView(timeRemaining: meditationTimeRemaining,
											label: "Meditate",
											duration: vm.meditationDuration,
											onActionTap: vm.stopMeditation)
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
			)
		}
	}
}

	struct TimerView: View {
		var timeRemaining: Int
		var label: String
		var duration: Int

		var onActionTap: (() -> Void)

		var body: some View {
			VStack {
				Spacer()

				ZStack {
					ProgressCircle()
					VStack {
						Text(timeRemaining.toMMSS())
							.font(.custom("SmoochSans-Medium", size: 90))
							.foregroundStyle(AppColors.background)

						Text(label)
							.font(.custom("Barlow-Bold", size: 18))
							.foregroundStyle(AppColors.background)
					}
				}

				Spacer()

				Text("Cancel")
					.font(.custom("Barlow-Bold", size: 18))
					.foregroundStyle(AppColors.foreground)
					.onTapGesture {
						onActionTap()
					}
			}
			.padding(.vertical)
		}
	}

	#Preview {
		TimerView(timeRemaining: 458, label: "Warmup", duration: 600, onActionTap: {})
	}


