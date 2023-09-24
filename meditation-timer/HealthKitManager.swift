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
}

