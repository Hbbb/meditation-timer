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
		GeometryReader { geometry in
			Path { path in
				let radius = min(geometry.size.width, geometry.size.height) / 2
				let startAngle = Angle(degrees: 0)
				let endAngle = Angle(degrees: 360 * (1 - self.progress))

				path.addArc(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
										radius: radius,
										startAngle: startAngle,
										endAngle: endAngle,
										clockwise: true)
			}
			.stroke(Colors.secondary, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
			.rotationEffect(Angle(degrees: -90))
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
