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
		timer.isRunning ? "pause" : "play"
	}

	var body: some View {
		HStack {
			// Decrement
			SecondaryControlButton(iconName: "minus", action: timer.decrementTime)
				.disabled(timer.isRunning)

			// Play/pause
			PrimaryControlButton(iconName: primaryControlIcon, action: {
				if timer.isRunning {
					timer.stopTimer()
				} else {
					timer.startTimer()
				}
			})

			// Increment
			SecondaryControlButton(iconName: "plus", action: timer.incrementTime)
				.disabled(timer.isRunning)
		}
	}
}

// TODO: What is the right way to condense these two view in Swift?
struct PrimaryControlButton: View {
	let iconName: String
	let action: () -> Void

	var body: some View {
		Button(action: action, label: {
			Image(systemName: iconName)
				.font(.system(size: 24))
				.frame(width: 44, height: 44)
				.background(Circle().fill(Color.gray.opacity(0.2)))
		})
	}
}

struct SecondaryControlButton: View {
	let iconName: String
	let action: () -> Void

	var body: some View {
		Button(action: action, label: {
			Image(systemName: iconName)
				.font(.system(size: 18))
				.frame(width: 32, height: 32)
				.background(Circle().fill(Color.gray.opacity(0.2)))
		})
	}
}

