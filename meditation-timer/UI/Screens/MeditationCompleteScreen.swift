//
//  CompletedMeditation.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/20/23.
//

import SwiftUI

struct MeditationCompleteScreen: View {
	@State var scale: CGFloat = 1
	var onTapComplete: (() -> Void)

	var body: some View {
		VStack {
			Text("Great job!")
				.font(.custom("SmoochSans-Medium", size: 90))
				.foregroundStyle(AppColors.foreground)

			Text("15:00 Meditation")
				.font(.custom("Barlow-Bold", size: 18))
				.foregroundStyle(AppColors.foreground)

			PrimaryButtonView(onTap: onTapComplete) {
				Image(systemName: "hand.thumbsup")
					.foregroundColor(.background)
					.font(.system(size: 28))
			}
			.padding(.top, 250)
		}
		.padding(.horizontal)
		.padding(.vertical)
		.frame(maxHeight: .infinity, alignment: .bottom)
		.onAppear {
			let animation = Animation.easeInOut(duration: 0.3).repeatCount(1, autoreverses: true)
			withAnimation(animation) {
				scale = 1.2
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				withAnimation(Animation.easeInOut(duration: 0.2)) {
					scale = 1.0
				}
			}
		}


	}
}

struct CompletedMeditation_Previews: PreviewProvider {
	static var previews: some View {
		MeditationCompleteScreen(onTapComplete: {})
	}
}
