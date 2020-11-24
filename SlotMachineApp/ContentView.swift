//
//  ContentView.swift
//  SlotMachineApp
//
//  Created by Nathan Mckenzie on 11/23/20.
//
//
//  ContentView.swift
//  FinalApp
//
//  Created by Nathan Mckenzie on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        
        NavigationView {
            
            VStack{
                Text("Mini Games")
                    .font(.title)
                    .background(
                        Image("gradient")
                            .ignoresSafeArea(.all)
                    )
                NavigationLink(destination: TicTacToeView()) {
                    
                    Image("tic")
                        .renderingMode(.original)
                        .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                }

                HStack{
                    
                    NavigationLink(destination: SlotMachineView()) {
                        
                        Image("slot")
                            .renderingMode(.original)
                            .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                    }
                    
                    
                    Spacer()
                    NavigationLink(destination: HelicopterView()) {
                        
                        Image("heli")
                            .renderingMode(.original)
                            .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        
                    }
                    
                    
                }


            }
            
            
        }
        
    }
    
}



struct HelicopterView: View{
    
    @State private var heliPosition = CGPoint(x:100, y: 100)
    @State private var obstPosition = CGPoint(x:1000, y: 300)
    @State private var isPaused = false
    @State private var score = 0
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
        var body: some View {
            
            GeometryReader { geo in
                
                
                ZStack{
                    
                    Helicopter()
                        .position(self.heliPosition)
                        .onReceive(self.timer) {_ in
                            self.gravity()
                        }
                    
                    Obstacle()
                        .position(self.obstPosition)
                        .onReceive(self.timer) {_ in
                            self.obstMove()
                        }
                    
                    Text("\(self.score)")
                        .foregroundColor(.white)
                        .position(x: geo.size.width - 100, y: geo.size.height / 10 )
                    
                    self.isPaused ? Button("Resume") { self.resume() } : nil
                    
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
                .gesture(
                    TapGesture()
                        .onEnded{
                            withAnimation{
                                self.heliPosition.y -= 100
                            }
                        })
                .onReceive(self.timer) { _ in
                    self.collisionDetection();
                    self.score += 1
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        
        
        func gravity() {
            withAnimation{
                self.heliPosition.y += 20
            }
        }
        
        func obstMove() {
            
            if self.obstPosition.x > 0
            {
                withAnimation{
                    self.obstPosition.x -= 20
                }
            }
            else
            {
                self.obstPosition.x = 1000
                self.obstPosition.y = CGFloat.random(in: 0...500)
                
            }
        }
        
        func pause() {
            self.timer.upstream.connect().cancel()
        }
        
        func resume() {
            
            self.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            
            self.obstPosition.x = 1000 // move obsitcle to starting position
            self.heliPosition = CGPoint(x: 100, y: 100) // helicopter to tarting position
            self.isPaused = false
            self.score = 0
        }
        
        func collisionDetection() {
            
            if abs(heliPosition.x - obstPosition.x) < (25 + 10) && abs(heliPosition.y - obstPosition.y) < (25 + 100) {
                self.pause()
                self.isPaused = true
            }
            
            
        }
        
        
        
    }
    



struct TicTacToeView: View{
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var currentAppChoice =  Int.random(in: 0 ..< 3)
    @State private var shouldWin = Bool.random()
    @State private var userScore = 0
    @State private var currentStep = 1
    @State private var showingAlert = false
    
    var body: some View{
        
        ZStack{
            
            Color.blue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25){
                
                Text("Steps: \(currentStep)/10")
                    .font(.title)
                Text("Your score is: \(userScore)")
                    .font(.title)
                Text(moves[currentAppChoice])
                    .font(.largeTitle)
                Text(shouldWin ? "Win" : "Lose")
                    .font(.largeTitle)
                    .bold()
                HStack(spacing: 8){
                    ForEach(0 ..< moves.count){ moveID in
                        
                        Button(action: {
                            
                            if self.currentStep == 10 {
                                self.currentStep = 0
                                self.userScore = 0
                                self.showingAlert = true
                                
                            } else{
                                self.calculateScore(withMove: moveID)
                            }
                            
                        }){
                            
                            Text("\(self.moves[moveID])")
                        }
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.red)
                        .clipShape(Capsule())
                        
                        .alert(isPresented: self.$showingAlert){
                            
                            Alert(title: Text("Game Over"), message: Text("Your Final Score Is \(self.userScore)"), dismissButton:
                                    .default(Text("OK")))
                        
                        }
                    }
                }
            }
            .foregroundColor(.white)
        }
    }
    
    func calculateScore(withMove currentUserChoice: Int){
        if currentAppChoice == currentUserChoice{
            userScore += 0
        }else if shouldWin {
            
            switch currentAppChoice{
            case 0:
                if currentUserChoice == 1{
                    userScore += 1
                }else{
                    userScore -= 1
                }
            case 1:
                if currentUserChoice == 2{
                    userScore += 1
                }else{
                    userScore -= 1
                }
            case 2:
                if currentUserChoice == 0{
                    userScore += 1
                } else{
                    userScore -= 1
                }
            default:
                break
            }
        }else{
            switch currentAppChoice{
            case 0:
                if currentUserChoice == 2{
                    userScore += 1
                }else{
                    userScore -= 1
                }
            case 1:
                if currentUserChoice == 0{
                    userScore += 1
                } else{
                    userScore -= 1
                }
            case 2:
                if currentUserChoice == 1{
                    userScore += 1
                }else{
                    userScore -= 1
                }
            default:
                break
            }
        }
        currentAppChoice = Int.random(in: 0 ..< 3)
        shouldWin = Bool.random()
        currentStep += 1
    }
    
}


struct SlotMachineView: View {
    @State private var symbols = ["clover", "lemon", "seven"]
    @State private var numbers = Array(repeating: 0, count: 9)
    @State private var backgrounds = Array(repeating: Color.white, count: 9)
    
    @State private var credits = 1000
    private var betAmount = 10
    var body: some View {
        
        ZStack{
            
            //background
            Rectangle().foregroundColor(Color(red: 200/255, green: 0/255, blue: 0/255))
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .foregroundColor(Color(red: 255/255, green: 0/255, blue: 0/255)).rotationEffect(Angle(degrees: 45)).ignoresSafeArea(.all)
            VStack{
                Spacer()
                //title
                HStack{

                    
                    Text("Slots Machine")
                        .bold()
                        .foregroundColor(.white)

                }.scaleEffect(2)
                Spacer()
                //credits counter
                Text("Credits: " + String(credits))
                    .foregroundColor(.black)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                Spacer()
                //cards
                VStack{
                    HStack{
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[0]], background: $backgrounds[0])
                        
                        
                        CardView(symbol: $symbols[numbers[1]],background: $backgrounds[1])
                        
                        
                        CardView(symbol: $symbols[numbers[2]], background: $backgrounds[2])
                        
                        
                        
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[3]], background: $backgrounds[3])
                        
                        
                        CardView(symbol: $symbols[numbers[4]],background: $backgrounds[4])
                        
                        
                        CardView(symbol: $symbols[numbers[5]], background: $backgrounds[5])
                        
                        
                        
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[6]], background: $backgrounds[6])
                        
                        
                        CardView(symbol: $symbols[numbers[7]],background: $backgrounds[7])
                        
                        
                        CardView(symbol: $symbols[numbers[8]], background: $backgrounds[8])
                        
                        
                        
                        Spacer()
                    }
                }
                Spacer()
                //Button
                
                HStack(spacing: 20)
                {
                    VStack{
                        Button(action:{
                            //TODO
                            //process a single spin
                            self.processResults()
                        }){
                            Text("Spin")
                                .bold()
                                .foregroundColor(.black)
                                .padding(.all,10)
                                .padding([.leading, .trailing], 30)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                        Text("\(betAmount) Credits")
                            .padding(.top, 10)
                            .font(.footnote)
                    }
                    VStack{
                        Button(action:{
                            //TODO
                            //process a single spin
                            self.processResults(true)
                        }){
                            Text("Max Spin")
                                .foregroundColor(.black)
                                .bold()
                                .padding(.all,10)
                                .padding([.leading, .trailing], 30)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                        Text("\(betAmount * 10) Credits")
                            .padding(.top, 10)
                            .font(.footnote)
                    }
                }
                Spacer()
            }
        }
    }
    
    func processResults(_ isMax: Bool = false){
        //sets background to white
        self.backgrounds = self.backgrounds.map({_ in
            Color.white
        })
        
        if isMax {
            //spin all the cards
            self.numbers = self.numbers.map({ _ in
                Int.random(in: 0...self.symbols.count - 1)
            })
        }
        else{
            //spin the middle row
            self.numbers[3] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[4] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[5] = Int.random(in: 0...self.symbols.count - 1)
        }
        
        //check winner
        processWin(isMax)
        
    }
    
    func processWin(_ isMax: Bool = false){
        
        var matches = 0
        
        if !isMax{
            
            //processing for single spin
            if self.numbers[3] == self.numbers[4] && self.numbers[4] == self.numbers[5]{
                
                //won
                matches += 1
                
                //update backgrounds to green
                self.backgrounds[3] = Color.green
                self.backgrounds[4] = Color.green
                self.backgrounds[5] = Color.green
                
            }
        }
        else{
            //processing for max spin
            
            //top row
            if self.numbers[0] == self.numbers[1] && self.numbers[1] == self.numbers[2]{
                //won
                matches += 1
                
                //update background to green
                self.backgrounds[0] = Color.green
                self.backgrounds[1] = Color.green
                self.backgrounds[2] = Color.green
                
            }
            //middle row
            if self.numbers[3] == self.numbers[4] && self.numbers[4] == self.numbers[5]{
                //won
                matches += 1
                
                //update background to green
                self.backgrounds[3] = Color.green
                self.backgrounds[4] = Color.green
                self.backgrounds[5] = Color.green
            }
            //bottom row
            if self.numbers[6] == self.numbers[7] && self.numbers[7] == self.numbers[8]{
                //won
                matches += 1
                
                //update background to green
                self.backgrounds[6] = Color.green
                self.backgrounds[7] = Color.green
                self.backgrounds[8] = Color.green
                
            }
        
            //diagnol top left to bottom right
            if self.numbers[0] == self.numbers[4] && self.numbers[4] == self.numbers[8]{
                //won
                matches += 1
                
                //update background to green
                self.backgrounds[0] = Color.green
                self.backgrounds[4] = Color.green
                self.backgrounds[8] = Color.green
                
            }
            //diagnol top right to bottom left
            if self.numbers[2] == self.numbers[4] && self.numbers[4] == self.numbers[4]{
                //won
                matches += 1
                
                //update background to green
                self.backgrounds[2] = Color.green
                self.backgrounds[4] = Color.green
                self.backgrounds[6] = Color.green
            }
        }
        //check matches and distribute credits
        if matches > 0{
            //at least 1 one
            self.credits += matches * betAmount * 5
        }
        else if !isMax {
            // 0 win, single spin
            self.credits -= betAmount
        }
        else{
            //0 wins, max spin
            self.credits -= betAmount * 10
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

