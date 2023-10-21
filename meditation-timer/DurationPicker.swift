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
	static let maxTicks: Int = 105

	var tickWidth: CGFloat = 5
	var tickHeight: CGFloat = 30
	var longTickHeight: CGFloat = 60

	var duration: Int = 60
	var tickInterval: Int = 4
	var tickColor: UIColor = .white

	init(frame: CGRect, tickColor: UIColor, duration: Int) {
		self.tickColor = tickColor
		self.duration = duration / 60

		super.init(frame: frame)

		self.backgroundColor = .clear
		self.showsHorizontalScrollIndicator = false

		setupTicks()
		setScrollPosition()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.showsHorizontalScrollIndicator = false
		setupTicks()
		setScrollPosition()
	}

	private func setupTicks() {
		for i in 0..<DurationPicker.maxTicks {
			let tick = UIView()

			tick.backgroundColor = tickColor
			tick.frame.size.width = tickWidth
			tick.frame.size.height = (i % tickInterval == 0) ? longTickHeight : tickHeight
			tick.frame.origin.x = CGFloat(i) * (tickWidth + 20)
			tick.frame.origin.y =  self.bounds.size.height - tick.frame.size.height
			tick.layer.cornerRadius = tickWidth / 2

			self.addSubview(tick)
		}

		self.contentSize = CGSize(width: CGFloat(DurationPicker.maxTicks) * (tickWidth + 20), height: self.frame.size.height)
	}

	private func setScrollPosition() {
		let minutes = self.duration
		let contentWidth = self.contentSize.width
		let offsetPerMinute = contentWidth / CGFloat(DurationPicker.maxTicks)
		let targetOffsetX = CGFloat(minutes) * offsetPerMinute

		self.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
			if traitCollection.userInterfaceStyle == .dark {
				tickColor = .white
			} else {
				tickColor = .black
			}

			setupTicks()
		}
	}

}

struct DurationPickerRepresentable: UIViewRepresentable {
	@Environment(\.colorScheme) var colorScheme
	@Binding var duration: Int

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

		// TODO: Perhaps publish the duration from here to remove the warning about not publishing in view updates
		func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIView(context: Context) -> DurationPicker {
		let customSlider = DurationPicker(
			frame: CGRect(x: 0, y: 0, width: 500, height: 70),
			tickColor: colorScheme == .dark ? UIColor.white : UIColor.black,
			duration: duration)

		customSlider.delegate = context.coordinator
		return customSlider
	}

	func updateUIView(_ uiView: DurationPicker, context: Context) {
		// View updates. Not sure when this is called
	}
}
