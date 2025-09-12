//
//  ContentView.swift
//  ClickCount
//
//  Created by Vexy on 11/09/2025.
//

import SwiftUI
import ConfettiSwiftUI
import AVFoundation

struct ContentView: View {
    @State private var counter = 0
    @State private var confettiCounter = 0
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Clicks: \(counter)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button(action: {
                counter += 1
                
                // Haptic Feedback
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                playSound(named: "click")
                
                if counter % 100 == 0 {
                    confettiCounter += 1
                    playSound(named: "milestone")
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
        .padding()
    }
    
    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Erro ao tocar o som: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
