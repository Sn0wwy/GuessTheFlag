//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nacho Alaves on 18/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingReset = false
    
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var answers = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                // Title of the app
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)


                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            flagTapped(number)
                            
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Your score was \(score)", isPresented: $showingReset) {
            Button("Restart", action: performReset)
        } message: {
            if(score == 8) {
                Text("You got them all right! Congratulations")
            } else if (score > 0) {
                Text("You got some wrong, be careful!")
            } else {
                Text("You should keep studying!")
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! that's the flag of \(countries[number])"
            score -= 2
        }
        showingScore = true
        answers += 1
    }
    
    func askQuestion() {
        if(answers == 8) {
            showingReset = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func performReset() {
        score = 0
        answers = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
