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
				.padding(.bottom, 80)
			Menu {
				Button("0s", action: { viewModel.warmupDuration = 0 })
				Button("30s", action: { viewModel.warmupDuration = 30 })
				Button("1m", action: { viewModel.warmupDuration = 60 })
			} label: {
				Text("Warmup")
					.padding(.horizontal, 100)
					.padding(.vertical, 15)
					.background(Color.gray)
					.foregroundColor(.white)
					.cornerRadius(15)
			}
			.padding(.bottom, 40)

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
