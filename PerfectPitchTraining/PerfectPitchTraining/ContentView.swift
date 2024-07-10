//
//  ContentView.swift
//  PerfectPitchTraining
//
//  Created by Evan Zhao on 7/9/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var debugLog: String = ""
    @State private var audioPlayer: AVAudioPlayer?
    @State private var lastPlayedNoteName: String? = nil
    @State private var showAnswer: Bool = false
    
    private var pitches: [String] {
        var pitchBuilder = [String]()
        for i in 1...7 {
            pitchBuilder.append("\(i)-a")
            pitchBuilder.append("\(i)-as")
            pitchBuilder.append("\(i)-b")
            pitchBuilder.append("\(i)-c")
            pitchBuilder.append("\(i)-cs")
            pitchBuilder.append("\(i)-d")
            pitchBuilder.append("\(i)-ds")
            pitchBuilder.append("\(i)-e")
            pitchBuilder.append("\(i)-f")
            pitchBuilder.append("\(i)-fs")
            pitchBuilder.append("\(i)-g")
            pitchBuilder.append("\(i)-gs")
        }
        return pitchBuilder
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button("Generate a new pitch") { playSound(replay: false) }
                    Button("Replay the last note") { playSound(replay: true)}
                }
                
                Section {
                    Toggle("Show answer", isOn: $showAnswer)
                    Text("Answer is: \(showAnswer ? lastPlayedNoteName ?? "" : "")")
                }
                
                Section {
                    Text("Log: \(debugLog)")
                }
            }
            .navigationTitle("Perfect Pitch Training")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func playSound(replay: Bool = false) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])

        guard let pitchFileName = replay ? lastPlayedNoteName: pitches.randomElement(),
              let url = Bundle.main.url(forResource: pitchFileName, withExtension: "wav") else {
            print("File not found")
            debugLog = "File not found"
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            debugLog = "Successful"
            lastPlayedNoteName = pitchFileName
        } catch {
            print("Error playing sound \(error.localizedDescription)")
            debugLog = "Error playing sound \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
