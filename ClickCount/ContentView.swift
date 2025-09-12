//
//  ContentView.swift
//  ClickCount
//
//  Created by Vexy on 11/09/2025.
//

import SwiftUI
import ConfettiSwiftUI
import AVFoundation

struct FloatingNumber: Identifiable, Equatable {
    let id = UUID()
    let value: Int
}

struct FloatingText: View {
    let value: Int
    @State private var yOffset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Text("+\(value)")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.green)
            .opacity(opacity)
            .offset(y: yOffset)
            .onAppear {
                withAnimation(.easeOut(duration: 1)) {
                    yOffset = -60
                    opacity = 0
                }
            }
    }
}

// MARK: Main ContentView
struct ContentView: View {
    @State private var counter = 0
    @State private var confettiCounter = 0
    @State private var floatingNumbers: [FloatingNumber] = []
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isDarkMode = false

    var body: some View {
        ZStack {
            // App Background
            (isDarkMode ? Color(red: 18/255, green: 18/255, blue: 18/255) : Color.white)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {

                Spacer(minLength: 50)

                Text("Clicks: \(counter)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? .white : .black)
                
                Button(action: {
                    counter += 1

                    // Haptic Feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()

                    // Click Sound
                    playSound(named: "click")

                    // Floating number
                    let newFloat = FloatingNumber(value: 1)
                    floatingNumbers.append(newFloat)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        floatingNumbers.removeAll { $0.id == newFloat.id }
                    }

                    // Confetti each 100 clicks
                    if counter % 100 == 0 {
                        confettiCounter += 1
                        playSound(named: "milestone")
                    }

                }) {
                    Text("Tap me!")
                        .font(.title)
                        .padding()
                        .background(isDarkMode ? Color.blue : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .scaleEffect(counter % 2 == 0 ? 1.0 : 1.05)
                        .animation(.easeInOut(duration: 0.1), value: counter)
                }

                Spacer()
            }
            .padding()

            // DarkMode Toggle Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isDarkMode.toggle()
                        }
                    }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(isDarkMode ? .yellow : .orange)
                            .padding()
                            .shadow(radius: 5)
                    }
                }
                Spacer()
            }
            .padding()

            // Floating numbers animation
            ForEach(floatingNumbers) { float in
                FloatingText(value: float.value)
                    .position(x: UIScreen.main.bounds.width / 2, y: 150)
            }

        }
        .confettiCannon(trigger: $confettiCounter, num: 30, colors: [.red, .blue, .green, .yellow])
    }
    // MARK: playSound Func
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
