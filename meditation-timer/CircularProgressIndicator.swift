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
					lineWidth: 30
				)
		Circle()
		// 2
			.trim(from: 0, to:  1 - progress)
			.stroke(
				Colors.secondary,
				style: StrokeStyle(
					lineWidth: 30,
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
			CircularProgressIndicator(progress: 0.75)
				.frame(width: 200, height: 200)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
