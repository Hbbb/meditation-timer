//
//  TimerControlsView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct PlayPauseButton: View {
	@EnvironmentObject var viewModel: AppViewModel

	let icon: String
	let action: (() -> Void)

	init(icon: String, action: @escaping () -> Void) {
		self.icon = icon
		self.action = action
	}

	var body: some View {
		ZStack {
			Circle()
				.fill(Colors.secondary)
				.frame(width: 90, height: 90)
				.onTapGesture {
					self.action()
					UIImpactFeedbackGenerator(style: .light).impactOccurred()
				}

			Image(systemName: icon)
				.font(.system(size: 24))
				.transition(.identity)
				.frame(width: 90, height: 90)
		}
	}
}
