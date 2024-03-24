//
//  PrimaryActionButton.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/25/23.
//

import SwiftUI

struct PrimaryActionButton: View {
	var text: String
	var onTap: (() -> Void)

	var body: some View {
		Circle()
			.frame(width: 106, height: 106)
			.foregroundColor(AppColors.foreground)
			.overlay(
				PlayTriangle()
					.frame(width: 18, height: 28)
					.rotationEffect(.degrees(180))
					.offset(x: 3)
					.foregroundColor(.background)
			)
			.mask(Circle())
			.onTapGesture {
				onTap()
			}
	}
}

struct PlayTriangle: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let midHeight = rect.midY
		let width = rect.width
		let height = rect.height

		path.move(to: CGPoint(x: 0, y: midHeight))
		path.addLine(to: CGPoint(x: width, y: 0))
		path.addLine(to: CGPoint(x: width, y: height))
		path.closeSubpath()

		return path
	}
}

#Preview {
	PrimaryActionButton(text: "Start", onTap: {})
}
