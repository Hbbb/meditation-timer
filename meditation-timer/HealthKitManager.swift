//
//  HealthKitManager.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/23/23.
//

import HealthKit

class HealthKitManager {
	static let shared = HealthKitManager()
	let healthStore = HKHealthStore()

	func requestHealthKitPermission(completion: @escaping (Bool, Error?) -> Void) {
		guard HKHealthStore.isHealthDataAvailable() else {
			completion(false, nil)
			return
		}
		
		let mindfulMinutes = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
		let typesToShare: Set = [mindfulMinutes]
		let typesToRead: Set<HKObjectType> = [mindfulMinutes]

		healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
			completion(success, error)
		}
	}

	func writeMindfulMinutes(minutes: Double, completion: @escaping (Bool, Error?) -> Void) {
		guard HKHealthStore.isHealthDataAvailable() else {
			completion(false, nil)
			return
		}

		let mindfulMinutes = HKObjectType.categoryType(forIdentifier: .mindfulSession)!

		// Calculate the start and end times based on the quantity of minutes
		let endDate = Date()
		let startDate = Calendar.current.date(byAdding: .minute, value: -Int(minutes), to: endDate)!

		// Create a mindful minutes sample with calculated start and end times
		let mindfulMinutesSample = HKCategorySample(type: mindfulMinutes, value: 0, start: startDate, end: endDate)

		// Save the mindful minutes sample to HealthKit
		healthStore.save(mindfulMinutesSample) { success, error in
			completion(success, error)
		}
	}
}

