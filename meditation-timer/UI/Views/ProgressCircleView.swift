//
//  ProgressCircle.swift
//  meditation-timer
//
//  Created by Harrison Borges on 2/12/24.
//

import SwiftUI

struct ProgressCircleView: View {
	// State variable to control the scale of the circle
	@State private var scale: CGFloat = 2

	var body: some View {
		Circle()
			.fill(AppColors.foreground)
			.frame(width: 125, height: 125)
			.scaleEffect(scale)
			.animation(
				.easeInOut(duration: 4)
					.repeatForever(autoreverses: true),
				value: scale
			)
			.onAppear {
				scale = 2.5
			}
	}
}

struct ProgressCircle_Previews: PreviewProvider {
	static var previews: some View {
		ProgressCircleView()
	}
}

#Preview {
    ProgressCircleView()
}
