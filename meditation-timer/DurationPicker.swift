//
//  UIDurationPicker.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/4/23.
//

import Foundation
import UIKit
import SwiftUI

class DurationPicker: UIScrollView {
	static let maxTicks: Int = 107

	var tickWidth: CGFloat = 5
	var tickHeight: CGFloat = 25
	var longTickHeight: CGFloat = 50
	var tickInterval: Int = 4
	var tickColor: UIColor = .white

	init(frame: CGRect, tickColor: UIColor) {
		super.init(frame: frame)
		self.tickColor = tickColor
		self.backgroundColor = .clear
		self.showsHorizontalScrollIndicator = false
		setupTicks()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.showsHorizontalScrollIndicator = false
		setupTicks()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.showsHorizontalScrollIndicator = false
		setupTicks()
	}

	private func setupTicks() {
		let centerPoint = self.frame.size.width / 2

		for i in 0..<DurationPicker.maxTicks {
			let tick = UIView()

			tick.backgroundColor = tickColor
			tick.frame.size.width = tickWidth
			tick.frame.size.height = (i % tickInterval == 0) ? longTickHeight : tickHeight
			tick.frame.origin.x = CGFloat(i) * (tickWidth + 20)
			tick.frame.origin.y = self.frame.size.height - tick.frame.size.height
			tick.layer.cornerRadius = tickWidth / 2
			setTickOpacity(centerPoint: centerPoint)

			self.addSubview(tick)
		}

		self.contentSize = CGSize(width: CGFloat(DurationPicker.maxTicks) * (tickWidth + 20), height: self.frame.size.height)
	}

	func setTickOpacity(centerPoint: CGFloat) {
		for tick in self.subviews {
			let distanceFromCenter = abs(centerPoint - tick.center.x)
			let maxDistance: CGFloat = 250  // you can adjust this value
			let opacity = max(1 - (distanceFromCenter / maxDistance), 0)
			tick.alpha = CGFloat(opacity)
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
			// User interface style changed, handle it here
			if traitCollection.userInterfaceStyle == .dark {
				tickColor = .white
				// Set up for dark mode
			} else {
				tickColor = .black
				// Set up for light mode
			}

			setupTicks()
		}
	}

}

struct DurationPickerRepresentable: UIViewRepresentable {
	@Environment(\.colorScheme) var colorScheme
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

			let centerPoint = scrollView.contentOffset.x + scrollView.bounds.width / 2
			if let picker = scrollView as? DurationPicker {
				picker.setTickOpacity(centerPoint: centerPoint)
			}
		}
	}

	func makeUIView(context: Context) -> DurationPicker {
		let customSlider = DurationPicker(
			frame: CGRect(x: 0, y: 0, width: 500, height: 50),
			tickColor: colorScheme == .dark ? UIColor.white : UIColor.black)

		customSlider.delegate = context.coordinator
		return customSlider
	}

	func updateUIView(_ uiView: DurationPicker, context: Context) {
		// View updates. Not sure when this is called
	}
}

