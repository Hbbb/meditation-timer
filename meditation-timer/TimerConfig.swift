//
//  TimerConfig.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import SwiftUI

struct TimerConfig: View {
	@EnvironmentObject var viewModel: AppViewModel
	let selections = ["0s", "30s", "1m"]
	@State var selection: String = "0s"

	var body: some View {
		VStack() {
			Spacer()
			Text("Meditation")
				.font(.largeTitle)
				.padding(.bottom, 40)

			Text(viewModel.timerDuration.toMMSS())
				.font(.title)
				.padding(.bottom, 20)
			DurationPickerRepresentable(duration: $viewModel.timerDuration)
				.frame(height: 50)
				.padding(.bottom, 40)

			// Warmup Picker
			Text("Warmup")
			HStack {
				Text("0s")
					.padding(.horizontal, 30)
					.padding(.vertical, 10)
					.background(viewModel.warmupDuration == 0 ? Color.blue : Color.gray)
					.foregroundColor(.white)
					.cornerRadius(50)
					.onTapGesture {
						viewModel.warmupDuration = 0
					}
				Text("30s")
					.padding(.horizontal, 30)
					.padding(.vertical, 10)
					.background(viewModel.warmupDuration == 30 ? Color.blue : Color.gray)
					.foregroundColor(.white)
					.cornerRadius(50)
					.onTapGesture {
						viewModel.warmupDuration = 30
					}
				Text("1m")
					.padding(.horizontal, 30)
					.padding(.vertical, 10)
					.background(viewModel.warmupDuration == 60 ? Color.blue : Color.gray)
					.foregroundColor(.white)
					.cornerRadius(50)
					.onTapGesture {
						viewModel.warmupDuration = 60
					}
			}
			.padding(.bottom, 120)

			Text("Start Timer")
				.frame(maxWidth: .infinity)
				.padding(.vertical, 20)
				.background(Color.green)
				.foregroundColor(.white)
				.cornerRadius(100)
				.onTapGesture {
					viewModel.startMeditation()
				}
		}
		.padding(.horizontal)
		.frame(maxHeight: .infinity, alignment: .bottom)
	}
}


struct TimerConfig_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			TimerConfig()
				.environmentObject(AppViewModel())
		}
	}
}
