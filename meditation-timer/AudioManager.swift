//
//  AudioManager.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/27/23.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject {
	var player: AVAudioPlayer?

	func start() {
		guard let url = Bundle.main.url(forResource: "complete", withExtension: "mp3") else {
			print("audio resource not found")
			return
		}

		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)

			player = try AVAudioPlayer(contentsOf: url)
			player?.play()
			player?.numberOfLoops = 100
		} catch {
			print("failed to init autioplayer", error)
		}
	}

}
