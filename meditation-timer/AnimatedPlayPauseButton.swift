//
//  AnimatedPlayPauseButton.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/26/23.
//

import SwiftUI

struct AnimatedPlayPauseButton: View {
	@State private var isPlaying: Bool = false
	@State private var animationAmount: CGFloat = 1.0

	var body: some View {
		Button(action: {
			withAnimation {
				isPlaying.toggle()
			}
		}) {
			HStack(spacing: isPlaying ? 2 : -2) {
				Rectangle()
					.frame(width: 15, height: isPlaying ? 30 : 0)
					.opacity(isPlaying ? 1 : 0)

				Rectangle()
					.frame(width: 15, height: isPlaying ? 30 : 0)
					.opacity(isPlaying ? 1 : 0)
			}
			.frame(width: 30, height: 30)
			.background(Color.blue)
			.rotationEffect(.degrees(isPlaying ? 0 : 90))
		}
		.buttonStyle(PlainButtonStyle())
	}
}

struct AnimatedPlayPauseButton_Previews: PreviewProvider {
	static var previews: some View {
		AnimatedPlayPauseButton()
	}
}
