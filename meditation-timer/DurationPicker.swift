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
	@State var duration: Int = 0

	var body: some View {
		VStack {
			Text("\(duration)")
			DurationPickerRepresentable(duration: $duration)
				.frame(height: 50)
		}
	}
}

class DurationPicker: UIScrollView {
	var tickWidth: CGFloat = 3
	var tickHeight: CGFloat = 15
	var longTickHeight: CGFloat = 30
	var tickInterval: Int = 4
	var maxTicks: Int = 90

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
		for i in 0..<maxTicks {
			let tick = UIView()
			tick.backgroundColor = .black
			tick.frame.size.width = tickWidth
			tick.frame.size.height = (i % tickInterval == 0) ? longTickHeight : tickHeight
			tick.frame.origin.x = CGFloat(i) * (tickWidth + 10)
			tick.frame.origin.y = self.frame.size.height - tick.frame.size.height
			self.addSubview(tick)
		}

		self.contentSize = CGSize(width: CGFloat(maxTicks) * (tickWidth + 10), height: self.frame.size.height)
	}
}

struct DurationPickerRepresentable: UIViewRepresentable {
	@Binding var duration: Int

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UIScrollViewDelegate {
		var parent: DurationPickerRepresentable

		init(_ parent: DurationPickerRepresentable) {
			self.parent = parent
		}

		var lastPosition: CGFloat = 0.0
		let threshold: CGFloat = 30.0
		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			let position = max(0, min(scrollView.contentOffset.x, scrollView.contentSize.width - scrollView.frame.width))

			if abs(lastPosition - position) >= threshold {
				let direction: Int = (lastPosition < position) ? 1 : -1
				parent.duration = max(1, min(90, parent.duration + direction))
				lastPosition = position
			}
		}
	}

	func makeUIView(context: Context) -> DurationPicker {
		let customSlider = DurationPicker(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
		customSlider.delegate = context.coordinator
		return customSlider
	}

	func updateUIView(_ uiView: DurationPicker, context: Context) {
		// Updates go here
	}
}

