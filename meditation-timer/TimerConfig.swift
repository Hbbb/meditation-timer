//
//  TimerConfig.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import SwiftUI

struct TimerConfig: View {
	@EnvironmentObject var vm: MeditationViewModel
	@State var selection: String = "0s"

	let selections = ["0s", "30s", "1m"]

	var body: some View {
		VStack() {
			Spacer()
			Text("Meditation")
				.font(.largeTitle)
				.padding(.bottom, 40)
				.foregroundColor(AppColors.foreground)

			Text(vm.meditationDuration.toMMSS())
				.font(.title)
				.padding(.bottom, 20)
				.foregroundColor(AppColors.foreground)
			DurationPickerRepresentable(duration: $vm.meditationDuration)
				.frame(height: 50)
				.padding(.bottom, 40)

			// Warmup Picker
			Text("Warmup")
				.foregroundColor(AppColors.foreground)
			HStack {
				Text("None")
					.padding(.horizontal, 20)
					.padding(.vertical, 10)
					.foregroundColor(vm.warmupDuration == 0 ? .white : .black)
					.background(vm.warmupDuration == 0 ? AppColors.darkGreen : AppColors.lightGreen)
					.cornerRadius(50)
					.onTapGesture {
						vm.warmupDuration = 0
					}
				Text("30s")
					.padding(.horizontal, 20)
					.padding(.vertical, 10)
					.foregroundColor(vm.warmupDuration == 30 ? .white : .black)
					.background(vm.warmupDuration == 30 ? AppColors.darkGreen : AppColors.lightGreen)
					.cornerRadius(50)
					.onTapGesture {
						vm.warmupDuration = 30
					}
				Text("45s")
					.padding(.horizontal, 20)
					.padding(.vertical, 10)
					.foregroundColor(vm.warmupDuration == 45 ? .white : .black)
					.background(vm.warmupDuration == 45 ? AppColors.darkGreen : AppColors.lightGreen)
					.cornerRadius(50)
					.onTapGesture {
						vm.warmupDuration = 45
					}
				Text("1m")
					.padding(.horizontal, 20)
					.padding(.vertical, 10)
					.foregroundColor(vm.warmupDuration == 60 ? .white : .black)
					.background(vm.warmupDuration == 60 ? AppColors.darkGreen : AppColors.lightGreen)
					.cornerRadius(50)
					.onTapGesture {
						vm.warmupDuration = 60
					}
			}
			.padding(.bottom, 120)

			Text("Start Timer")
				.frame(maxWidth: .infinity)
				.padding(.vertical, 20)
				.background(AppColors.green)
				.foregroundColor(.white)
				.cornerRadius(100)
				.onTapGesture {
					vm.startMeditation()
				}
		}
		.padding(.horizontal)
		.padding(.vertical)
		.frame(maxHeight: .infinity, alignment: .bottom)
	}
}


struct TimerConfig_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TimerConfig()
				.environmentObject(MeditationViewModel())
		}
	}
}
