//
//  PrimaryActionButton.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/25/23.
//

import SwiftUI

struct PrimaryButtonView<Content: View>: View {
	var onTap: (() -> Void)
	let content: Content

	init(onTap: @escaping () -> Void, @ViewBuilder content: () -> Content) {
		self.onTap = onTap
		self.content = content()
	}

	var body: some View {
		Circle()
			.frame(width: 106, height: 106)
			.foregroundColor(AppColors.foreground)
			.overlay(
				content
					.frame(width: 18, height: 18)
					.foregroundColor(.background)
			)
			.mask(Circle())
			.onTapGesture {
				onTap()
			}
	}
}

struct CompleteButton: View {
	var onTap: (() -> Void)

	var body: some View {
		Circle()
			.frame(width: 106, height: 106)
			.foregroundColor(AppColors.foreground)
			.overlay(
				Image(systemName: "hand.thumbsup")
					.foregroundColor(.background)
					.font(.system(size: 28))
			)
			.mask(Circle())
			.onTapGesture {
				onTap()
			}
	}
}

#Preview {
	PrimaryButtonView(onTap: {}) {
		Image(systemName: "play.fill")
			.offset(x: 3)
	}
}
