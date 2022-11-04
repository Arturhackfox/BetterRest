//
//  ContentView.swift
//  BetterSleep
//
//  Created by Arthur Sh on 01.11.2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = deafaultWakeTime
    @State private var hoursOfSleep = 8.0
    @State private var coffeAmount = 1
    
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var deafaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components ) ?? Date.now
    }
    
    var body: some View {
        NavigationStack{
            Form {
                VStack(alignment: .leading, spacing: 0){
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("wake up", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0){
                    Text("Desired amount of sleep")
                    Stepper("\(hoursOfSleep.formatted())", value: $hoursOfSleep, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0){
                    Text("Daily coffe intake")
                    Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", value: $coffeAmount, in: 1...20)
                }
              
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Culculate", action: calculate)
            }
            .alert(alertTitle, isPresented: $showingAlert){
                Button("OK") {}
            }message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculate() {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: hoursOfSleep, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "You ideal time to go to bed..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, something went wrong"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
