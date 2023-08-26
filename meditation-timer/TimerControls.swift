//
//  TimerControlsView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct TimerControls: View {
	@EnvironmentObject var timer: TimerModel

	private var primaryControlIcon: String {
		timer.isRunning ? "stop.fill" : "play.fill"
	}

	var body: some View {
		HStack {
			PrimaryControlButton(iconName: primaryControlIcon, action: {
				if timer.isRunning {
					timer.stopTimer()
				} else {
					timer.startTimer()
				}
			})

		}
	}
}

struct PrimaryControlButton: View {
	let iconName: String
	let action: () -> Void

	var body: some View {
		Button(action: action, label: {
			Image(systemName: iconName)
				.font(.system(size: 24))
				.frame(width: 90, height: 90)
				.background(Circle().fill(Colors.secondary))
		})
	}
}
