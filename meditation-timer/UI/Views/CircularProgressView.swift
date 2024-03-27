//
//  CircularProgressIndicator.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/25/23.
//

import Foundation
import SwiftUI

struct CircularProgressView: View {
	@State private var elapsedTime: Double = 0.0
	var duration: Double

	let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

	var body: some View {
		let progress = elapsedTime / duration

		ZStack {
			Circle()
				.stroke(
					AppColors.yellow.opacity(0.5),
					lineWidth: 15
				)
		Circle()
			.trim(from: progress, to: 1)
			.stroke(
				AppColors.yellow,
				style: StrokeStyle(
					lineWidth: 15,
					lineCap: .round
				)
			)
			.rotationEffect(.degrees(-90))
			.animation(.easeOut, value: progress)
		}
		.onReceive(timer) { _ in
			if elapsedTime < duration {
				elapsedTime += 0.1
			} else {
				timer.upstream.connect().cancel()
			}
		}
	}
}

struct CircularProgressIndicator_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			CircularProgressView(duration: 60)
				.frame(width: 225, height: 225)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
