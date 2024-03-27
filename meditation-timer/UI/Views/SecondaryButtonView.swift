//
//  SecondaryButtonView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 3/27/24.
//

import SwiftUI

struct SecondaryButtonView: View {
	var onTap: (() -> Void)

	var body: some View {
		Text("Cancel")
			.font(.custom("Barlow-Bold", size: 18))
			.foregroundStyle(AppColors.foreground)
			.onTapGesture {
				onTap()
			}
	}
}

#Preview {
	SecondaryButtonView(onTap: {})
}
