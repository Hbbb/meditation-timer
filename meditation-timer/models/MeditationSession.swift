//
//  MeditationModel.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/23/23.
//

import Foundation

struct MeditationSession: Codable {
	let date: Date
	let duration: TimeInterval
}
