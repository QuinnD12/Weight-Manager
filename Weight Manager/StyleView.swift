//
//  StyleView.swift
//  Weight Manager
//
//  Created by Quinn B. Davis on 11/7/23.
//

import SwiftUI

struct cfontStruct: ViewModifier {
    var size: Double
    var shade: Double
    
    func body(content: Content) -> some View {
        content
            .font(.custom("DIN Condensed", size: size))
            .foregroundStyle(Color(white: shade))
    }
}

extension View {
    func cfont(size: Double, shade: Double = 0.4) -> some View {
       modifier(cfontStruct(size: size, shade: shade))
    }
}
