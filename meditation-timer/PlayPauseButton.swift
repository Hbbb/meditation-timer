//
//  TimerControlsView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct PlayPauseButton: View {
	@EnvironmentObject var timer: TimerModel
	@EnvironmentObject var audioManager: AudioManager
	@State private var rotation: Double = 0

	private var icon: String {
		timer.isRunning ? "stop.fill" : "play.fill"
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(Colors.secondary)
				.frame(width: 90, height: 90)
				.onTapGesture {
					withAnimation {
						if timer.isRunning {
							rotation = 0
							timer.stop()
						} else {
							rotation += 90
							timer.start()
						}
					}
					print("start audio player")
					audioManager.playAudio(trackOffset: timer.initialDurationSeconds)
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
