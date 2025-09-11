//
//  ContentView.swift
//  ClickCount
//
//  Created by Vexy on 11/09/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @State private var counter = 0
    @State private var confettiCounter = 0
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Clicks: \(counter)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(action: {
                counter += 1
                if counter % 100 == 0 {
                    confettiCounter += 1
                }
            }) {
                Text("Tap me!")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            
        }
        .confettiCannon(trigger: $confettiCounter, num: 30, colors: [.red, .blue, .green, .yellow])
    }
}

#Preview {
    ContentView()
}
