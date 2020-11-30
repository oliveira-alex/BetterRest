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
		DatePicker("Please enter a date", selection: $wakeUp, in: Date()...) // displayedComponents: .hourAndMinute
			.labelsHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
