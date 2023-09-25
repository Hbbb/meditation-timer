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
				Text("15s")
					.padding(.horizontal, 20)
					.padding(.vertical, 10)
					.foregroundColor(vm.warmupDuration == 15 ? .white : .black)
					.background(vm.warmupDuration == 15 ? AppColors.darkGreen : AppColors.lightGreen)
					.cornerRadius(50)
					.onTapGesture {
						vm.warmupDuration = 15
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

			PrimaryActionButton(text: "Start Timer", onTap: vm.startMeditation)
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
