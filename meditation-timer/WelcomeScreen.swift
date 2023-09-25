//
//  WelcomeScreen.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/25/23.
//

import SwiftUI

struct WelcomeScreen: View {
	@EnvironmentObject var vm: MeditationViewModel

	var body: some View {
		VStack {
			Image(systemName: "figure.mind.and.body")
				.font(.system(size: 48))
				.padding(.bottom, 30)

			Text("Meditation Timer uses HealthKit to read and write mindful minutes to the Health app so you can track your progress as you meditate.")
				.padding(.bottom, 200)

			PrimaryActionButton(text: "Grant access to Health", onTap: {
				HealthKitManager.shared.requestHealthKitPermission() { succeeded, err in
					DispatchQueue.main.async {
						vm.didCompleteOnboarding()
					}
				}
			})
			.padding(.bottom, 20)

			Text("Skip")
				.foregroundStyle(.gray)
				.onTapGesture {
					vm.didCompleteOnboarding()
				}
		}
		.padding(30)
		.frame(maxHeight: .infinity, alignment: .bottom)
	}
}

#Preview {
	WelcomeScreen()
}
