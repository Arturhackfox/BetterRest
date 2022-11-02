//
//  ContentView.swift
//  BetterSleep
//
//  Created by Arthur Sh on 01.11.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var date = Date.now
    @State private var hoursOfSleep = 8.0
    @State private var coffeAmount = 1
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("wake up", selection: $date, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                Stepper("\(hoursOfSleep.formatted())", value: $hoursOfSleep, in: 4...12, step: 0.25)
                
                Text("Daily coffe intake")
                Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", value: $coffeAmount, in: 1...20)
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Culculate", action: calculate)
            }
        }
    }
    
    func calculate() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
