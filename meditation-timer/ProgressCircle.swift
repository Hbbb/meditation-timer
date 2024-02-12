//
//  ProgressCircle.swift
//  meditation-timer
//
//  Created by Harrison Borges on 2/12/24.
//

import SwiftUI

struct ProgressCircle: View {
	// State variable to control the scale of the circle
	@State private var scale: CGFloat = 1.0

	var body: some View {
		Circle()
			.frame(width: 100, height: 100)
			.scaleEffect(scale)
			.animation(
				.easeInOut(duration: 4)
					.repeatForever(autoreverses: true),
				value: scale
			)
			.onAppear {
				scale = 2.3
			}
	}
}

struct ProgressCircle_Previews: PreviewProvider {
	static var previews: some View {
		ProgressCircle()
	}
}

#Preview {
    ProgressCircle()
}
