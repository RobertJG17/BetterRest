//
//  ContentView.swift
//  BetterRest
//
//  Created by Robert Guerra on 10/30/20.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date()
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want do wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                // More to come
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
