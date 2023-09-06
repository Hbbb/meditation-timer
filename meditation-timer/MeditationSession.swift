//
//  MeditationSession.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/5/23.
//

import Foundation

/**
 * MeditationSession represents a user's meditation session.
 * All durations are in seconds
 */
struct MeditationSession {
	let id: UUID
	var duration: Int
	var warmupDuration: Int?
}
