import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class FirebaseManager: ObservableObject {
    private let ref = Database.database().reference()
    
    func push(_ value: String, under: String="") {
        ref.child("data/" + under).setValue(value)
    }
    
    func pull(under: String="") async -> String {
        let v = try? await ref.child("data/" + under).getData()
        
        return v!.value as? String ?? "Unknown"
    }
    func pullRO(under: String="") async -> String {
        let v = try? await ref.child("under").getData()
        
        return v!.value as? String ?? "Unknown"
    }
}


func getDate() -> String {
    let now = Date.now
    let formatter = DateFormatter()
    formatter.dateFormat = "ss/mm/HH/dd/MM/yyyy"
    
    return formatter.string(from: now)
}

func shortFormat(_ date: String) -> String {
    let longFormatter = DateFormatter()
    longFormatter.dateFormat = "ss/mm/HH/dd/MM/yyyy"
    
    let d = longFormatter.date(from: date)!
    
    let shortFormatter = DateFormatter()
    shortFormatter.dateFormat = "MM/dd/yy(HH:mm)"
    
    return shortFormatter.string(from: d)
}

func miniumumEntry(_ entrys: [Entry]) -> Double {
    var min = entrys[0].value
    
    for i in entrys {
        if i.value < min {
            min = i.value
        }
    }
    
    return min
}

func maximumEntry(_ entrys: [Entry]) -> Double {
    var max = entrys[0].value
    
    for i in entrys {
        if i.value > max {
            max = i.value
        }
    }
    
    return max
}
