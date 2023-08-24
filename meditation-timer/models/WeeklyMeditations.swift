//
//  WeeklyMeditations.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/23/23.
//

import Foundation

final class WeeklyMeditations {
	private var sessions: [MeditationSession] = []
	private let storageManager = MeditationStorageManager()

	static let shared = WeeklyMeditations()

	private var startDateOfWeek: Date {
		let calendar = Calendar.current
		let now = Date()
		let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
		return startOfWeek
	}

	// Loads sessions for the current week from storage
	private init() {
		if let loadedSessions = storageManager.loadSessions(forWeekStarting: startDateOfWeek) {
			sessions = loadedSessions
		}
	}

	// Adds a new session for the current week
	func addSession(duration: TimeInterval) {
		let session = MeditationSession(date: Date(), duration: duration)
		sessions.append(session)
		storageManager.saveSessions(sessions, forWeekStarting: startDateOfWeek)
	}

	// Retrieves sessions for a specific day
	func sessions(for day: Date) -> [MeditationSession] {
		return sessions.filter { Calendar.current.isDate($0.date, inSameDayAs: day) }
	}

	// Resets sessions for a new week
	func resetSessions() {
		sessions.removeAll()
		storageManager.clearSessions(forWeekStarting: startDateOfWeek)
	}
}
