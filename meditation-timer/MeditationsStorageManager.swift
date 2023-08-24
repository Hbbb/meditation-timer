//
//  MeditationsStorageManager.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/23/23.
//

import Foundation

class MeditationStorageManager {
	private let fileManager = FileManager.default
	private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

	// Save sessions to a JSON file for a specific week
	func saveSessions(_ sessions: [MeditationSession], forWeekStarting startDate: Date) {
		let fileName = filename(forWeekStarting: startDate)
		let fileURL = documentsDirectory.appendingPathComponent(fileName)

		do {
			let jsonData = try JSONEncoder().encode(sessions)
			try jsonData.write(to: fileURL)
		} catch {
			print("Error saving sessions: \(error)")
		}
	}

	// Load sessions from a JSON file for a specific week
	func loadSessions(forWeekStarting startDate: Date) -> [MeditationSession]? {
		let fileName = filename(forWeekStarting: startDate)
		let fileURL = documentsDirectory.appendingPathComponent(fileName)

		guard fileManager.fileExists(atPath: fileURL.path) else { return nil }

		do {
			let jsonData = try Data(contentsOf: fileURL)
			let sessions = try JSONDecoder().decode([MeditationSession].self, from: jsonData)
			return sessions
		} catch {
			print("Error loading sessions: \(error)")
			return nil
		}
	}

	// Clears sessions for a specific week
	func clearSessions(forWeekStarting startDate: Date) {
		let fileName = filename(forWeekStarting: startDate)
		let fileURL = documentsDirectory.appendingPathComponent(fileName)

		if fileManager.fileExists(atPath: fileURL.path) {
			do {
				try fileManager.removeItem(at: fileURL)
			} catch {
				print("Error deleting sessions file: \(error)")
			}
		}
	}

	// Generates a filename based on the week's start date
	private func filename(forWeekStarting startDate: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return "sessions_\(dateFormatter.string(from: startDate)).json"
	}
}
