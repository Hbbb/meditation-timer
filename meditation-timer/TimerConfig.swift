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
			Text(vm.meditationDuration.toMMSS())
				.font(.custom("Barlow-Black", size: 110))
				.padding(.bottom, 10)
				.foregroundColor(AppColors.foreground)

			DurationPickerRepresentable(duration: $vm.meditationDuration)
				.frame(height: 70)
				.padding(.bottom, 60)

			// Warmup Picker
			Text("Warmup")
				.foregroundColor(AppColors.foreground)
				.font(.custom("Barlow-Regular", size: 20))

			Picker("Warmup", selection: $vm.warmupDuration) {
				Text("None").tag(0)
				Text("15s").tag(15)
				Text("30s").tag(30)
				Text("1m").tag(60)
			}
			.pickerStyle(.segmented)
			.padding(.bottom, 120)

			PrimaryActionButton(text: "Start", onTap: vm.startMeditation)
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
