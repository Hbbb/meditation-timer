//
//  DataController.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/26/23.
//
import CoreData
import Foundation

class DataController: ObservableObject {
	let container = NSPersistentContainer(name: "MeditationTimer")

	init() {
		container.loadPersistentStores { _, error in
			if let error = error {
				print("Core data failed to load: \(error)")
			}

		}
	}
}
