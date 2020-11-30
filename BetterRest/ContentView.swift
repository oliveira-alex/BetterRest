//
//  ContentView.swift
//  BetterRest
//
//  Created by Alex Oliveira on 30/11/20.
//

import SwiftUI

struct ContentView: View {
	@State private var wakeUp = Date()
	
    var body: some View {
		let formatter = DateFormatter()
		formatter.timeStyle = .full
		let dateString = formatter.string(from: Date())
		
		return VStack(spacing: 30) {
			Text("dateString: \(dateString)")
				
			DatePicker("Please enter a date", selection: $wakeUp, in: Date()...) // displayedComponents: .hourAndMinute
				.labelsHidden()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
