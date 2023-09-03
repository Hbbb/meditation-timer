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

			VStack {
				Text("Meditation")
				HStack {
					IncDecButton(.minus) {
						viewModel.removeTime()
					}

					Text(viewModel.timerDuration.toMMSS())
						.font(.system(size: 64))
						.padding(.horizontal, 20)

					IncDecButton(.plus) {
						viewModel.addTime()
					}
				}
			}
			.padding(.vertical)

			VStack {
				Text("Warmup")
				HStack {
					IncDecButton(.minus) {

					}

					Text(viewModel.warmupDuration.toMMSS())
						.font(.system(size: 64))
						.padding(.horizontal, 20)

					IncDecButton(.plus) {

					}
				}
			}
			.padding(.vertical)
			.padding(.bottom, 100)

			HStack {
				Image(systemName: "speaker.wave.2.fill")

				PlayPauseButton(icon: "play.circle") {
					Logger.info("Start timer", context: .timerConfig)
					viewModel.startTimer()
				}
				.padding(.horizontal, 80)

				Image(systemName: "square.and.arrow.down.fill")
			}.padding([.top, .bottom])
		}
		.frame(maxHeight: .infinity, alignment: .bottom)
	}
}

enum IncDecControl: String {
	case plus
	case minus
}

struct IncDecButton: View {
	let icon: IncDecControl
	let action: (() -> Void)

	init(_ control: IncDecControl, action: @escaping () -> Void) {
		icon = control
		self.action = action
	}

	var body: some View {
		Image(systemName: icon.rawValue)
			.font(.system(size: 32))
			.onTapGesture {
				self.action()
			}
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
