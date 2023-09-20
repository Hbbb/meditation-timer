//
//  AlarmPlayer.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import Foundation
import AudioToolbox
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
	private var audioPlayer: AVAudioPlayer?

	private func setupAudioSession() {
		do {
			try AVAudioSession.sharedInstance().setCategory(
				.playback, // .playAndRecord,
				options: [.duckOthers, /* .defaultToSpeaker */])
		} catch {
			Logger.error("Could not set category", error, context: .alarmPlayer)
		}

		do {
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			Logger.error("Could not activate session", error, context: .alarmPlayer)
		}

		do {
			try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
		} catch {
			Logger.error("Could not override output", error, context: .alarmPlayer)
		}
	}

	func playSound(soundName: String, volume: Float) {
		self.setupAudioSession()
		let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)

		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
		} catch let error as NSError {
			audioPlayer = nil
			Logger.error("Failed to init AVAudioPlayer", error, context: .alarmPlayer)
			return
		}

		guard let audioPlayer = self.audioPlayer else {
			return
		}

		audioPlayer.delegate = self
		audioPlayer.prepareToPlay()

		self.audioPlayer!.play()
	}

	func stopSound() {
		self.audioPlayer?.stop()
		AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
	}

	func isPlaying() -> Bool {
		return self.audioPlayer?.isPlaying == true
	}
}

// MARK: AVAudioPlayerDelegate protocol methods
extension SoundManager {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		self.stopSound()
	}

	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		guard let err = error else {
			Logger.warn("audioPlayerDecodeErrorDidOccur encountered unknown error", context: .alarmPlayer)
			return
		}

		Logger.error("audioPlayerDecodeErrorDidOccur", err, context: .alarmPlayer)
	}
}
