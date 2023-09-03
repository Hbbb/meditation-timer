//
//  TimerConfig.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import SwiftUI

struct TimerConfig: View {
	@EnvironmentObject var viewModel: AppViewModel

	var body: some View {
		VStack() {
			Text("Meditation")
			HStack {
				Image(systemName: "minus")
				Text("\(viewModel.timerDuration)")
					.font(.system(size: 42))
				Image(systemName: "plus")
			}

			Text("Warmup")
			HStack {
				Image(systemName: "minus")
				Text("\(viewModel.timerDuration)")
					.font(.system(size: 42))
				Image(systemName: "plus")
			}

			HStack {
				Image(systemName: "speaker.wave.2.fill")
				PlayPauseButton(icon: "play.fill") {
					Logger.info("Start timer", context: .timerConfig)
					viewModel.startTimer()
				}

				Image(systemName: "square.and.arrow.down.fill")
			}
		}
		.frame(maxHeight: .infinity, alignment: .bottom)
	}
}

struct TimerConfig_Previews: PreviewProvider {
	static var previews: some View {
		TimerConfig()
			.environmentObject(AppViewModel())
	}
}
