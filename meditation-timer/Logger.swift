//
//  Logger.swift
//  meditation-timer
//
//  Created by Harrison Borges on 9/2/23.
//

struct Logger {
	static var isLoggingEnabled = true
	
	static func debug(_ message: String, context: LogContext) {
		log(message, level: .debug, context: context)
	}

	static func info(_ message: String, context: LogContext) {
		log(message, level: .info, context: context)
	}

	static func warn(_ message: String, context: LogContext) {
		log(message, level: .warning, context: context)
	}

	static func error(_ error: Error, context: LogContext) {
		log(error.localizedDescription, level: .error, context: context)
	}

	private static func log(_ message: String, level: LogLevel, context: LogContext) {
		print("[\(level.rawValue.uppercased())][\(context.rawValue)] \(message)")
	}

	enum LogLevel: String {
		case debug, info, warning, error
	}

	enum LogContext: String {
		case backgroundTask, view, model
	}
}
