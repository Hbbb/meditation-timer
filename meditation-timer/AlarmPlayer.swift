//
//  AlarmPlayer.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import Foundation
import AudioToolbox
import AVFoundation
import MediaPlayer

protocol AlarmAudio {
	func playSound(soundName: String, volume: Float)

	func stopSound()

	func resumeVolumeFadeIn()

	func pauseFadeInAndQuiet()

	func isPlaying() -> Bool
}

class AlarmPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate, AlarmAudio {

	private var audioPlayer: AVAudioPlayer?
//	private let deviceVolumeHandler = DeviceVolumeHandler()
//	private var volumeManager: PlayerVolumeStateManager?

	private var originalVolume: Float?
	private var originalAudioSessionCategory: AVAudioSession.Category?
	private var originalAudioSessionOptions: AVAudioSession.CategoryOptions?

	private func setupAudioSession() {
		originalAudioSessionCategory = AVAudioSession.sharedInstance().category
		originalAudioSessionOptions = AVAudioSession.sharedInstance().categoryOptions

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

	// TODO: maybe set device volume to the alarm volume
	// and fade volume to 100% (which is capped at device volume)
	func playSound(soundName: String, volume: Float) {
		// Set up the audio session to prep for playback
		self.setupAudioSession()
		// Set up the MPVolumeView so we can set the volume to max
//		deviceVolumeHandler.setupVolumeView()
		// Vibrate phone first
//		AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

		// Set vibrate callback
//		let vibrateSoundID = SystemSoundID(kSystemSoundID_Vibrate)

//		AudioServicesAddSystemSoundCompletion(
//			vibrateSoundID, nil, nil, { (_: SystemSoundID, _: UnsafeMutableRawPointer?) -> Void in
//				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//			}, nil)

		let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)

		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
		} catch let error as NSError {
			audioPlayer = nil
			Logger.error("Failed to init AVAudioPlayer", error, context: .alarmPlayer)
			return
		}

		guard let audioPlayer = self.audioPlayer else {
//			Logger.error("Audio player is nil", context: .alarmPlayer)
			return
		}

		audioPlayer.delegate = self
		audioPlayer.prepareToPlay()

//		self.originalVolume = AVAudioSession.getCurrentVolume()

		// Set device volume to max
//		deviceVolumeHandler.setDeviceVolume(volume)

		// Negative number means loop infinity
		self.audioPlayer!.play()

//		audioPlayer.volume = 0

		// Fade in the sound
//		volumeManager = PlayerVolumeStateManager(player: audioPlayer)
//		volumeManager?.fadeIn()
	}

	func resumeVolumeFadeIn() {
//		volumeManager?.resume(fromQuiet: true)
	}

	func pauseFadeInAndQuiet() {
//		volumeManager?.quietAlarm()
	}

	func stopSound() {
		self.audioPlayer?.stop()
		AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)

//		guard let volume = self.originalVolume else {
//			Logger.error("Original volume was nil", context: .alarmPlayer)
//			deviceVolumeHandler.setDeviceVolume(0.4)
//			return
//		}
//		deviceVolumeHandler.setDeviceVolume(volume)
//		deviceVolumeHandler.releaseVolumeView()

		do {
			// Set the audio session back to what it was (bg session perhaps)
			try AVAudioSession.sharedInstance().setCategory(
				originalAudioSessionCategory!,
				options: originalAudioSessionOptions!)
		} catch { Logger.error("Failed to setCategory on AVAudioSession", error, context: .alarmPlayer) }
	}

	func isPlaying() -> Bool {
		return self.audioPlayer?.isPlaying == true
	}
}

// MARK: AVAudioPlayerDelegate protocol methods
extension AlarmPlayer {
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
