//
//  TimerControlsView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct PlayPauseButton: View {
	let icon: String
	let action: (() -> Void)

	init(icon: String, action: @escaping () -> Void) {
		self.icon = icon
		self.action = action
	}

	var body: some View {
		Image(systemName: icon)
			.font(.system(size: 64))
			.onTapGesture {
				self.action()
				UIImpactFeedbackGenerator(style: .light).impactOccurred()
			}
	}
}

struct PlayPauseButton_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			PlayPauseButton(icon: "play.circle") {
				print("Play")
			}

			PlayPauseButton(icon: "stop.circle") {
				print("Stop")
			}
		}
	}
}
