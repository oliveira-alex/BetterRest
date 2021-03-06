//
//  ContentView.swift
//  BetterRest
//
//  Created by Alex Oliveira on 30/11/20.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Sleep amount")
                    .accessibilityValue( modf(sleepAmount).1.isZero ?
                                        "\(Int(sleepAmount)) hours" :
                                        "\(Int(sleepAmount)) point \(Int(modf(sleepAmount).1 * 100) == 50 ? 5 : Int(modf(sleepAmount).1 * 100)) hours"
                    )
                }
                
                Section(header: Text("Daily coffee intake")) {
//                    Picker("Number of cups", selection: $coffeeAmount) {
//                        ForEach(1 ..< 21) { amount in
//                            if amount == 1 {
//                                Text("\(amount) cup")
//                            } else {
//                                Text("\(amount) cups")
//                            }
//                        }
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Intake")
                    .accessibilityValue( coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups")
//                    .pickerStyle(WheelPickerStyle())
//                    .frame(height: 50)
                }
                
                Section(header: Text("Recommended bedtime")) {
                    Text(recommendedBedtime)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                                    Button(action: calculateBedtime) {
//                                        Text("Calculate")
//                                    }
//            )
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var recommendedBedtime: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Calculation Error"
        }
    }
    
//    func calculateBedtime() {
//        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//
//        do {
//            let model = try SleepCalculator(configuration: MLModelConfiguration())
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is..."
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//        }

//        showingAlert = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
