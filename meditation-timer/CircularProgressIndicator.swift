//
//  CircularProgressIndicator.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/25/23.
//

import Foundation
import SwiftUI

struct CircularProgressIndicator: View {
	var progress: Double

	var body: some View {
		ZStack {
			Circle()
				.stroke(
					Colors.secondary.opacity(0.5),
					lineWidth: 15
				)
		Circle()
			.trim(from: 1 - progress, to: 1)
			.stroke(
				Colors.secondary,
				style: StrokeStyle(
					lineWidth: 15,
					lineCap: .round
				)
			)
			.rotationEffect(.degrees(-90))
			.animation(.easeOut, value: progress)
		}
	}
}

struct CircularProgressIndicator_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			CircularProgressIndicator(progress: 0.70)
				.frame(width: 225, height: 225)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
