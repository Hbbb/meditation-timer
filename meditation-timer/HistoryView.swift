//
//  HistoryView.swift
//  meditation-timer
//
//  Created by Harrison Borges on 8/21/23.
//

import SwiftUI

struct HistoryView: View {
	var body: some View {
		Grid {
			GridRow {
				Text("M")
				Text("T")
				Text("W")
				Text("T")
				Text("F")
				Text("Sa")
				Text("Su")
			}
			Divider()
			GridRow {
				Circle()
					.fill(Color.green)
					.frame(width: 10, height: 10)
				Circle()
					.fill(Color.green)
					.frame(width: 10, height: 10)
			}
		}
	}
}
