//
//  ProfileView.swift
//  WEIGHT MANAGEMENT
//
//  Created by Quinn B. Davis on 11/1/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var fm: FirebaseManager
    
    let weightClasses = ["Select Target", "106", "113", "120", "126", "132", "138", "144", "150", "157", "165", "175", "190", "215", "285"]
    
    @State private var selectedClass = "Select Target"
    @State private var name = ""
    @State private var alerted = false
    @State private var alerted1 = false
    
    var body: some View {
        Text("Create Profile")
            .cfont(size: 75, shade: 0)
            .padding(.top, 40)
        
        Spacer()
        
        HStack {
            TextField("Username", text: $name)
                .cfont(size: 40, shade: 0.5)
                Picker("Select Class", selection: $selectedClass) {
                    ForEach(weightClasses, id: \.self) {
                        Text($0)
                    }
                }.tint(.black)
                    .scaleEffect(1.25)
        }.padding()
        
        Spacer(minLength: 275)
        
        Button("Create") {
            if selectedClass != "Select Target" {
                let nameCopy = name
                let targetCopy = selectedClass
                
                Task {
                    let target = await fm.pull(under: "\(nameCopy)/target")
                    if target != "Unknown" {
                        alerted = true
                    } else {
                        fm.push(targetCopy, under: "\(nameCopy)/target")
                        fm.push("0", under: "\(nameCopy)/entrys/entrycount")
                    }
                }
                
                name = ""
                selectedClass = "Select Target"
            } else {
                alerted1 = true
            }
        }.alert("Account Already Exsists", isPresented: $alerted) {
            Button("OK", role: .cancel) { }
        }.alert("Select A Target Weight", isPresented: $alerted1) {
            Button("OK", role: .cancel) { }
        }.cfont(size: 70, shade: 0.35)
            .padding(.bottom, 150)
    }
}

#Preview {
    ProfileView(fm: FirebaseManager())
}
