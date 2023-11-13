//
//  ContentView.swift
//  Weight Manager
//
//  Created by Quinn B. Davis on 11/7/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fm = FirebaseManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Weight")
                    .cfont(size: 110, shade: 0)
                    .padding(.top, 60)
                Text("Management")
                    .cfont(size: 90, shade: 0)
                
                Spacer()
                
                NavigationLink(destination: AddView(fm: fm).toolbarRole(.editor)) {
                    Label("Log Weight", systemImage: "plus.app")
                        .cfont(size: 50)
                }
                NavigationLink(destination: LogView(fm: fm).toolbarRole(.editor)) {
                    Label("View Log", systemImage: "book")
                        .cfont(size: 50)
                        .padding()
                }
                NavigationLink(destination: ProfileView(fm: fm).toolbarRole(.editor)) {
                    Label("Create Profile", systemImage: "person.badge.key")
                        .cfont(size: 50)
                }
                
                Spacer(minLength: 150)
            }
        }.tint(Color(white: 0.3))
    }
}

#Preview {
    ContentView()
}
