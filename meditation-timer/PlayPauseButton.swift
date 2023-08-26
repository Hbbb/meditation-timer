//
//  TimerControlsView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct PlayPauseButton: View {
	@EnvironmentObject var timer: TimerModel

	private var icon: String {
		timer.isRunning ? "stop.fill" : "play.fill"
	}

	var body: some View {
		Button(action: {
			if timer.isRunning {
				timer.stop()
			} else {
				timer.start()
			}
		}, label: {
			Image(systemName: icon)
				.font(.system(size: 24))
				.frame(width: 90, height: 90)
				.background(Circle().fill(Colors.secondary))
		})
	}
}
