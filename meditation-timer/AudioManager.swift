//
//  AudioManager.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/27/23.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject {
	var chimePlayer: AVAudioPlayer?
	var silencePlayer: AVAudioPlayer?

	init() {
		setupChimePlayer()
		setupSilencePlayer()

		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print("failed to configure AVAudioSession")
		}
	}

	func playAudio(trackOffset: Int) {
		silencePlayer?.currentTime = 0
		silencePlayer?.numberOfLoops = -1
		silencePlayer?.play()

		print(trackOffset)

		DispatchQueue.main.asyncAfter(wallDeadline: .now() + Double(trackOffset)) {
			print("play chime")
			self.stopPlaying()
			self.chimePlayer?.play()
		}
	}

	func stopPlaying() {
		silencePlayer?.stop()
		silencePlayer?.currentTime = 0
	}

	private func setupSilencePlayer() {
		guard let url = Bundle.main.url(forResource: "silence", withExtension: "mp3") else {
			return
		}
		do {
			silencePlayer = try AVAudioPlayer(contentsOf: url)
			silencePlayer?.numberOfLoops = -1  // Infinite loop
		} catch {
			print("Player not available")
		}
	}

	private func setupChimePlayer() {
		guard let url = Bundle.main.url(forResource: "chakra-bowl", withExtension: "mp3") else {
			return
		}
		do {
			chimePlayer = try AVAudioPlayer(contentsOf: url)
		} catch {
			print("Chime player not available")
		}
	}

	func start(trackOffset: Int) {
		guard let url = Bundle.main.url(forResource: "complete", withExtension: "mp3") else {
			print("audio resource not found")
			return
		}

		do {
			chimePlayer = try AVAudioPlayer(contentsOf: url)

			chimePlayer?.play()
			chimePlayer?.numberOfLoops = 0
			chimePlayer?.currentTime = Double(3600 - trackOffset)
		} catch {
			print("failed to init autioplayer", error)
		}
	}
}
