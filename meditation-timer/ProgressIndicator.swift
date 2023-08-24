//
//  ProgressIndicator.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct ProgressIndicator: View {
	var progress: CGFloat

	var body: some View {
		GeometryReader { geometry in
			let radius = min(geometry.size.width, geometry.size.height) / 2

			ZStack {
				// Background path for the complete semicircle
				Path { path in
					path.addArc(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
											radius: radius,
											startAngle: .degrees(90),
											endAngle: .degrees(360),
											clockwise: false)
				}
				.stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
				.foregroundColor(.gray)

				// Foreground path for the progress
				Path { path in
					let endAngle = 360 - (270 * (1 - progress))

					path.addArc(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
											radius: radius,
											startAngle: .degrees(90),
											endAngle: .degrees(endAngle),
											clockwise: false)
				}
				.stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
				.foregroundColor(.blue)
			}
			.rotationEffect(.degrees(45))
		}
	}

}

struct ProgressIndicator_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			ProgressIndicator(progress: 0.5)
			Spacer()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}





