//
//  BackgroundTask.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

import AVFoundation

extension Logger {
	fileprivate static func info(_ message: String) {
		Logger.info(message, context: .backgroundTask)
	}
}

/**
 https://github.com/yarodevuci/backgroundTask/blob/master/test/BackgroundTask/BackgroundTask.swift
 */
class BackgroundTask: ObservableObject {

	// MARK: - Vars

	// This needed to be static for some reason...
	// https://stackoverflow.com/questions/32036146/how-to-play-a-sound-using-swift
	static var player: AVAudioPlayer?
	var timer = Timer()

	/**
	 Sets to true by default and will be set to false in the timer
	 This is to see if the timer gets restared / killed
	 */
	var isFirstTimerFire: Bool = true
	var firstFireTimer: Timer?

	// MARK: - Methods

	func start() {
		Logger.info("Starting")

		NotificationCenter.default.addObserver(self,
																					 selector: #selector(handleInterruption),
																					 name: AVAudioSession.interruptionNotification,
																					 object: nil/*AVAudioSession.sharedInstance()*/)
		self.playAudio()

		// A timer used for debugging - it'll tell us if the task is working in the background at
		// 10 second and 20 second increments (then stop)
		self.firstFireTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { _ in
			if self.isFirstTimerFire {
				Logger.info("First fire")
				self.isFirstTimerFire = false
			} else {
				Logger.info("Second fire")
				self.firstFireTimer?.invalidate()
				// Logger.info("Background timer still going")
			}
		})

		// Another more intense timer used for debugging - since it has a lot of log writing,
		// it can be turned off in settings.
		if Logger.isLoggingEnabled {
			// Only if the setting is turned on should we fire these logs every x minutes
			Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
				guard Logger.isLoggingEnabled else {
					return
				}
				if BackgroundTask.player?.isPlaying == true {
					Logger.info("Playing")
				} else {
					Logger.info("Not playing")
				}
			}
		}
	}

	func stop() {
		NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
		BackgroundTask.player?.stop()
	}

	func startIfNotStarted() {
		self.playAudio()
	}

	@objc private func handleInterruption(_ notification: Notification) {
		Logger.info("handleAudioInterruption")
		//        if notification.name == AVAudioSession.interruptionNotification && notification.userInfo != nil {
		//            let info = notification.userInfo!
		//            var intValue = 0
		//            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
		//            if intValue == 1 { playAudio() }
		//        }
		guard let userInfo = notification.userInfo,
					let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
					let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
			return
		}

		// Switch over the interruption type.
		switch type {
			case .began:
				// An interruption began. Update the UI as needed.
				Logger.info("Session interrupted. Trying to play anyways.")
				playAudio()
			case .ended:
				// An interruption ended. Resume playback, if appropriate.
				guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
				let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
				if options.contains(.shouldResume) {
					// Interruption ended. Playback should resume.
					Logger.info("Interruption ended. Playback will resume.")
					playAudio()
				} else {
					// Interruption ended. Playback should not resume.
					Logger.info("Interruption ended. Playback shouldn't resume, but will anyways.")
					playAudio()
				}

			default: ()
		}

	}

	/**
	 https://medium.com/@oleary.audio/avaudiosession-insert-pun-48e616142f75
	 https://developer.apple.com/documentation/avfoundation/avaudiosession
	 */
	private func playAudio() {
		do {
			if BackgroundTask.player?.isPlaying == true {
				Logger.info("Already playing")
				return
			}
			let bundle = Bundle.main.path(forResource: "blank", ofType: "wav")
			let alertSound = URL(fileURLWithPath: bundle!)

			try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
			try AVAudioSession.sharedInstance().setActive(true)
			try BackgroundTask.player = AVAudioPlayer(contentsOf: alertSound)
			// Play audio forever by setting num of loops to -1
			BackgroundTask.player!.numberOfLoops = -1
			BackgroundTask.player!.volume = 0.01
			BackgroundTask.player!.prepareToPlay()
			BackgroundTask.player!.play()
			Logger.info("Started playing")
		} catch {
			Logger.error("Failed to playAudio", error, context: .backgroundTask)
		}
	}
}
