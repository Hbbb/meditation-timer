//
//  TimerControlsView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct PlayPauseButton: View {
	@EnvironmentObject var viewModel: AppViewModel
	@State private var rotation: Double = 0

	private var icon: String {
		viewModel.timerIsRunning ? "stop.fill" : "play.fill"
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(Colors.secondary)
				.frame(width: 90, height: 90)
				.onTapGesture {
					withAnimation {
						if viewModel.timerIsRunning {
							rotation = 0
							viewModel.stopTimer()
						} else {
							rotation += 90
							viewModel.startTimer()
						}
					}

					UIImpactFeedbackGenerator(style: .light).impactOccurred()
				}
			Image(systemName: icon)
				.font(.system(size: 24))
				.rotationEffect(.degrees(rotation))
				.transition(.identity)
				.frame(width: 90, height: 90)
		}
	}
}
