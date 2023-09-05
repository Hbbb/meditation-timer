//
//  UIDurationPicker.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/4/23.
//

import Foundation
import UIKit
import SwiftUI

struct TestSlider: View {
	@State var duration: Int = 1

	var body: some View {
		VStack {
			Text("\(duration)")
			DurationPickerRepresentable(duration: $duration)
				.frame(height: 50)
		}
	}
}

class DurationPicker: UIScrollView {
	static let maxTicks: Int = 107

	var tickWidth: CGFloat = 5
	var tickHeight: CGFloat = 25
	var longTickHeight: CGFloat = 50
	var tickInterval: Int = 4

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		self.showsHorizontalScrollIndicator = false
		setupTicks()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.showsHorizontalScrollIndicator = false
		setupTicks()
	}

	private func setupTicks() {
		for i in 0..<DurationPicker.maxTicks {
			let tick = UIView()
			tick.backgroundColor = i % tickInterval == 0 ? .black : .gray
			tick.frame.size.width = tickWidth
			tick.frame.size.height = (i % tickInterval == 0) ? longTickHeight : tickHeight
			tick.frame.origin.x = CGFloat(i) * (tickWidth + 20)
			tick.frame.origin.y = self.frame.size.height - tick.frame.size.height
			tick.layer.cornerRadius = tickWidth / 2
			self.addSubview(tick)
		}

		self.contentSize = CGSize(width: CGFloat(DurationPicker.maxTicks) * (tickWidth + 20), height: self.frame.size.height)
	}
}

struct DurationPickerRepresentable: UIViewRepresentable {
	@Binding var duration: Int

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UIScrollViewDelegate {
		var parent: DurationPickerRepresentable
		let hapticFeedback = UIImpactFeedbackGenerator(style: .light)

		init(_ parent: DurationPickerRepresentable) {
			self.parent = parent
		}

		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			let rawDuration = Int(scrollView.contentOffset.x / (scrollView.contentSize.width / CGFloat(DurationPicker.maxTicks))) + 1
			let newDuration = min(90, max(1, rawDuration)) * 60

			if newDuration != parent.duration {
				parent.duration = newDuration
				hapticFeedback.impactOccurred()
			}
		}
	}

	func makeUIView(context: Context) -> DurationPicker {
		let customSlider = DurationPicker(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
		customSlider.delegate = context.coordinator
		return customSlider
	}

	func updateUIView(_ uiView: DurationPicker, context: Context) {
		// View updates. Not sure when this is called
	}
}

