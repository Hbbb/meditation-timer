//
//  PrimaryActionButton.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/25/23.
//

import SwiftUI

struct PrimaryActionButton: View {
	var text: String
	var onTap: (() -> Void)

	var body: some View {
		Text(text)
			.frame(maxWidth: .infinity)
			.padding(.vertical, 18)
			.background(AppColors.green)
			.foregroundColor(.white)
			.font(.custom("Barlow-Bold", size: 16))
			.cornerRadius(100)
			.onTapGesture {
				onTap()
			}
	}
}

#Preview {
	PrimaryActionButton(text: "Start", onTap: {})
}
