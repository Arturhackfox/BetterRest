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
    @State private var showingResult = false
    
    var calculatedBedtime: String {


        var bedTime = "Please set all input values"

        do {
            
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: hoursOfSleep, coffee: Double(coffeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep

           
            bedTime = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true
        }

        return bedTime
    }
    
    
    static var deafaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components ) ?? Date.now
    }
    
  
    var body: some View {
        NavigationStack{
            Form {
                Section{
                   
                    DatePicker("wake up", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        .font(.headline)
                }
                Section{
                   
                    Stepper("\(hoursOfSleep.formatted())", value: $hoursOfSleep, in: 4...12, step: 0.25)
                       
                } header: {
                    Text("Desired amount of sleep")
                        .font(.headline)

                }
               
                Section{
                    Picker(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", selection: $coffeAmount) {
                        ForEach(1..<21) { number in
                            Text("\(number-1)")
                                
                        }


                        
                    }
                    
                } header: {
                    Text("Daily coffe intake")
                        .font(.headline)
                }

                
                Section{
                        Text(calculatedBedtime)
                        .font(.title)
                }
                
                
                
              
            }
            .navigationTitle("Better Rest")
            .alert(alertTitle, isPresented: $showingAlert){
                Button("OK") {}
            }message: {
                Text(alertMessage)
            }
        }
        
        
    } // end of view
    
//    func calculate() {
//        do{
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//
//            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: hoursOfSleep, coffee: Double(coffeAmount))
//
//            let sleepTime = wakeUp - prediction.actualSleep
//            alertTitle = "You ideal time to go to bed..."
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, something went wrong"
//        }
//        showingAlert = false
//
//    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

