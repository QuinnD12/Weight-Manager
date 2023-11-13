//
//  LogView.swift
//  WEIGHT MANAGEMENT
//
//  Created by Quinn B. Davis on 11/1/23.
//

import SwiftUI
import Charts

struct Entry: Identifiable {
    var id = UUID()
    
    var date: String
    var value: Double
}

struct LogView: View {
    @ObservedObject var fm: FirebaseManager
    
    @State private var name = ""
    @State private var alerted = false
    @State var entrys: [Entry] = []
    @State var targetVar: Double = 0
    @State var minVal: Double = 100
    @State var maxVal: Double = 300
    
    var body: some View {
        Text("View Log")
            .cfont(size: 75, shade: 0)
            .padding(.top, 40)
        
        TextField("Username", text: $name)
            .cfont(size: 40, shade: 0.5)
            .padding()
        
        Button("Load") {
            let nameCopy = name
            
            Task {
                let target = await fm.pull(under: "\(nameCopy)/target")
                let entryCount = await fm.pull(under: "\(nameCopy)/entrys/entrycount")
                
                if entryCount == "Unknown" {
                    alerted = true
                } else {
                    print(entryCount)
                    for i in 1...(Int(entryCount)!) {
                        let value = await fm.pull(under: "\(nameCopy)/entrys/entry\(i)/value")
                        let date = await fm.pull(under: "\(nameCopy)/entrys/entry\(i)/date")
                        
                        entrys.append(Entry(date: date, value: Double(value)!))
                    }
                    
                   
                    targetVar = Double(target)!
                    minVal = (miniumumEntry(entrys) < targetVar ? miniumumEntry(entrys) : targetVar) - 3
                    maxVal = (maximumEntry(entrys) > targetVar ? maximumEntry(entrys) : targetVar) + 3
                }
            }
            
            name = ""
        }.alert("Account Not Found", isPresented: $alerted) {
            Button("OK", role: .cancel) { }
        }.cfont(size: 70, shade: 0.35)
        
        ScrollView(.horizontal) {
            Chart(entrys) {
                RuleMark(y: .value("Weight", targetVar))
                    .annotation(position: .bottom,
                                alignment: .bottomTrailing) {
                        Text(String(targetVar))
                            .foregroundColor(.green)
                    }.foregroundStyle(.green)
                
                LineMark(
                    x: .value("Date", shortFormat($0.date)),
                    y: .value("Weight", $0.value)
                ).foregroundStyle(.blue)
            }.chartYScale(domain: minVal...maxVal)
                .frame(width: CGFloat(entrys.count) * 90)
        }
    }
}

#Preview {
    LogView(fm: FirebaseManager())
}
