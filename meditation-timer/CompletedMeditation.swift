//
//  CompletedMeditation.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/20/23.
//

import SwiftUI

struct CompletedMeditation: View {
	@State var scale: CGFloat = 1
	var onTapComplete: (() -> Void)

	var body: some View {
		VStack {
			Image(systemName: "checkmark.circle")
				.font(.system(size: 84))
				.foregroundColor(AppColors.green)
				.scaleEffect(scale)

			Text("Great job!")

			Text("Complete")
				.frame(maxWidth: .infinity)
				.padding(.vertical, 20)
				.background(AppColors.green)
				.foregroundColor(.white)
				.cornerRadius(100)
				.padding(.top, 250)
				.onTapGesture {
					onTapComplete()
				}
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
		CompletedMeditation(onTapComplete: {})
	}
}
