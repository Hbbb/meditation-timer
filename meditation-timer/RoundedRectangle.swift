//
//  RoundedRectangleView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/16/23.
//

import SwiftUI

struct RoundedRectangle<Content: View>: View {
	let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		GeometryReader { geometry in
			VStack {
				Spacer()
				ZStack(alignment: .top) {
					Color.gray
						.frame(width: geometry.size.width, height: geometry.size.height * 0.60)
						.cornerRadius(150, corners: [.topLeft, .topRight])

					content
						.padding(.top)
				}
			}
		}
		.edgesIgnoringSafeArea(.bottom)
	}
}

// Custom corner radius implementation
extension View {
	func cornerRadius(_ radius: Double, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}

struct RoundedCorner: Shape {
	var radius: Double = .infinity
	var corners: UIRectCorner = .allCorners

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}

struct RoundedRectangleView_Previews: PreviewProvider {
	static var previews: some View {
		RoundedRectangle {
			Text("Your Cooooooontent Here")
				.padding()
				.background(Color.white)
				.cornerRadius(10)
		}
	}
}


