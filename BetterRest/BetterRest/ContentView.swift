//
//  ContentView.swift
//  BetterRest
//
//  Created by Robert Guerra on 10/30/20.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    // Initializers for sleep model
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    // Alert controller variables
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // Computed Properties
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // MARK: - Helper Functions
    func calculateBedTime() -> String {
        let model = SleepCalculator()
        
        // Gathering Data from Date() class and storing them in properties
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        var returnMessage = ""
        
        do {
            // Using ML model to gather prediction
            // and adjusting the sleep time accordingly
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            // Formatting the presentation once the sleep time is acquired
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            returnMessage = formatter.string(from: sleepTime)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, an unexpected error occured when calculating your bedtime"
            showingAlert = true
        }
        
        
        return returnMessage
    }
    
    // MARK: - App Layout View
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want do wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                Section(header: Text("Daily coffee intake")) {
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        Text(coffeeAmount == 1 ? "1 cup": "\(coffeeAmount) cups")
                    }
                }
                Section(header: Text("Suggested BedTime:")) {
                    Text("\(calculateBedTime())")
                }
            }.navigationTitle("Better Rest")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
