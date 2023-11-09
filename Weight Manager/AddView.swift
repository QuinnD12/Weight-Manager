import SwiftUI

struct AddView: View {
    @ObservedObject var fm: FirebaseManager
    
    @State private var name = ""
    @State private var weight = ""
    @State private var alerted = false
    @State private var alertedProfile = false
    
    var body: some View {
        VStack {
            Text("Log Weight")
                .cfont(size: 75, shade: 0)
                .padding(.top, 40)
            
            Spacer()
            
            VStack {
                TextField("Username", text: $name)
                    .cfont(size: 40, shade: 0.5)
                
                TextField("Weight", text: $weight)
                    .cfont(size: 40, shade: 0.5)
            }.padding()
            
            Spacer(minLength: 200)

            Button("Save") {
                if name != "" {
                    if let w = Double(weight) {
                        
                        let nameCopy = name
                        
                        Task {
                            let target = await fm.pull(under: "\(nameCopy)/target")
                            if target == "Unknown" {
                                alertedProfile = true
                            } else {
                                
                                var entrynum = await fm.pull(under: "\(nameCopy)/entrys/entrycount")
                                entrynum = String(Int(entrynum)! + 1)
                                
                                let path = "\(nameCopy)/entrys/entry\(entrynum)/"
                                
                                fm.push(String(w), under: path+"value")
                                fm.push(getDate(), under: path+"date")
                                fm.push(entrynum, under: "\(nameCopy)/entrys/entrycount")
                            }
                        }
                        
                        name = ""
                        weight = ""
                    } else { alerted = true }
                } else { alerted = true }
            }.alert("Invalid Entry", isPresented: $alerted) {
                Button("OK", role: .cancel) { }
            }.alert("No Account Found", isPresented: $alertedProfile) {
                Button("OK", role: .cancel) { }
            }.cfont(size: 70, shade: 0.35)
                .padding(.bottom, 150)

        }
    }
}

#Preview {
    AddView(fm: FirebaseManager())
}

