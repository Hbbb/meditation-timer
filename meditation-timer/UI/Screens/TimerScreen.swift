//
//  TimerScreen.swift
//  meditation-timer
//
//  Created by Harrison Borges on 3/27/24.
//

import SwiftUI

struct TimerScreen: View {
	var timeRemaining: Int
	var label: String
	var duration: Int

	var onActionTap: (() -> Void)

	var body: some View {
		VStack {
			Spacer()

			ZStack {
				ProgressCircleView()
				VStack {
					Text(timeRemaining.toMMSS())
						.font(.custom("SmoochSans-Medium", size: 90))
						.foregroundStyle(AppColors.background)

					Text(label)
						.font(.custom("Barlow-Bold", size: 18))
						.foregroundStyle(AppColors.background)
				}
			}

			Spacer()
			SecondaryButtonView(onTap: onActionTap)
		}
		.padding(.vertical)
	}
}


#Preview {
	TimerScreen(timeRemaining: 458, label: "Warmup", duration: 600, onActionTap: {})
}
