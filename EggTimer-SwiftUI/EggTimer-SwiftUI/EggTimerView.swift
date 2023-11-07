//
//  ContentView.swift
//  EggTimer-SwiftUI
//
//  Created by Patrik Cesnek on 15/01/2021.
//

import AVFoundation
import SwiftUI

struct EggTimerView: View {
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var eggType = "Soft"
    var eggHardness = ["Soft", "Medium", "Hard"]
    @State var progress: CGFloat = 0.0
    @State var total: CGFloat = 100.0
    @State private var isActive = false
    @State private var isDone = false
    
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            Color(red: 0.01, green: 0.6, blue: 1)
                .ignoresSafeArea()
            VStack {
                if !isDone {
                Text(!isActive ? "How do you like your eggs?" : "\(eggType)")
                    .font(.title)
                    .padding()
                Spacer()
                HStack {
                    Button(action: {
                        // Set timer for 3 minutes
                        eggType = eggHardness[0]
                        setTimer(for: 3)
                    }) {
                        Image("soft_egg")
                            .resizable()
                            .scaledToFit()
                    }
                    Button(action: {
                        // Set timer for 4 minutes
                        eggType = eggHardness[1]
                        setTimer(for: 4)
                    }) {
                        Image("medium_egg")
                            .resizable()
                            .scaledToFit()
                    }
                    Button(action: {
                        // Set timer for 7 minutes
                        eggType = eggHardness[2]
                        setTimer(for: 7)
                    }) {
                        Image("hard_egg")
                            .resizable()
                            .scaledToFit()
                    }
                
                }
                .padding()
                                
                ProgressView(value: progress, total: total)
                    .progressViewStyle(HardnessProgressViewStyle(progress: progress, total: total))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding()
                    .onReceive(timer) { _ in
                        if isActive {
                            if progress < total {
                                self.progress += 1.0
                            } else if progress == total {
                                // play sound to indicate that it's done
                                done()
                            } else {
                                resetTimer()
                            }
                        }
                    }
                
                Spacer()
                } else {
                    Text("Your \(eggType) eggs are done.")
                        .font(.largeTitle)
                    
                    Button("Reset") {
                        isDone = false
                        resetTimer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .foregroundColor(.white)
                    .font(.title)
                    
                }
            }
        }
    }
    
    func resetTimer() {
        isActive = false
        progress = 0
        total = 100
        timer.upstream.connect().cancel()
        playSound(sound: "alarm_sound", type: "mp3", playing: false)
    }
    
    func setTimer(for minutes: CGFloat) {
        isActive = true
        total = minutes * 540
        progress += 1
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }
    
    func done() {
        playSound(sound: "alarm_sound", type: "mp3", playing: true)
        isActive = false
        isDone = true
        progress = 0
    }
    
    func playSound(sound: String, type: String, playing: Bool) {
        if playing {
            if let path = Bundle.main.path(forResource: sound, ofType: type) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    audioPlayer?.play()
                } catch {
                    print("There was an error playing sound: \(error.localizedDescription)")
                }
            }
        } else {
            audioPlayer?.stop()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EggTimerView()
    }
}
