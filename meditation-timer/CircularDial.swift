//
//  CircularDial.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct CircularDial: View {
	@Binding var angle: Double
	@State private var startAngle: Double = 0
	let tickPoints: [Double] = [3, 5, 10, 15, 20, 30, 60] // in minutes
	let maxAngle: Double = 360
	let indicatorDiameter: CGFloat = 20

	var body: some View {
		let drag = DragGesture()
			.onChanged { value in
				let vectorStart = CGVector(dx: value.startLocation.x - 75, dy: value.startLocation.y - 75)
				let startRadians = atan2(vectorStart.dy, vectorStart.dx)

				let vectorCurrent = CGVector(dx: value.location.x - 75, dy: value.location.y - 75)
				let currentRadians = atan2(vectorCurrent.dy, vectorCurrent.dx)

				let deltaAngle = Double(currentRadians - startRadians) * 180 / .pi
				self.angle = (startAngle + deltaAngle).truncatingRemainder(dividingBy: maxAngle)
				if self.angle < 0 {
					self.angle += maxAngle
				}

				self.angle = nearestTickPointAngle(from: angle)
			}
			.onEnded { _ in
				self.startAngle = angle
			}

		return GeometryReader { geometry in
			ZStack {
				Circle()
					.stroke(lineWidth: 5)

				TickMarksView(angles: [0, 60, 120, 180, 240, 300, 360])

				// Indicator Circle
				Circle()
					.frame(width: indicatorDiameter, height: indicatorDiameter)
					.offset(x: cos(CGFloat(angle - 90) * .pi / 180) * (geometry.size.width / 2 - indicatorDiameter / 2),
									y: sin(CGFloat(angle - 90) * .pi / 180) * (geometry.size.width / 2 - indicatorDiameter / 2))
			}
			.gesture(drag)
		}
	}

	private func tickPointAngle(index: Int) -> Double {
		return Double(index) * maxAngle / Double(tickPoints.count)
	}

	private func nearestTickPointAngle(from angle: Double) -> Double {
		let angles = [0, 60, 120, 180, 240, 300, 360] // Corresponding to 3, 5, 10, 15, 20, 30, 60
		let closest = angles.min(by: { abs(Int(angle) - $0) < abs(Int(angle) - $1) }) ?? 0
		return Double(closest)
	}
}

struct TickMarksView: View {
	let angles: [Double]

	var body: some View {
		GeometryReader { geometry in
			ForEach(angles.indices, id: \.self) { index in
				Path { path in
					let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
					let angle = angles[index] - 90 // Adjusting for SwiftUI coordinate system
					let tickLength: CGFloat = 10
					let radius = geometry.size.width / 2
					let innerPoint = CGPoint(x: center.x + cos(CGFloat(angle) * .pi / 180) * (radius - tickLength),
																	 y: center.y + sin(CGFloat(angle) * .pi / 180) * (radius - tickLength))
					let outerPoint = CGPoint(x: center.x + cos(CGFloat(angle) * .pi / 180) * radius,
																	 y: center.y + sin(CGFloat(angle) * .pi / 180) * radius)

					path.move(to: innerPoint)
					path.addLine(to: outerPoint)
				}
				.stroke()
			}
		}
	}
}


