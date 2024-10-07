//
//  Instructions.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-07.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) var dissmiss
    
    var body: some View {
        ZStack {
            infoBackgroundImage()
            
            VStack {
                Image(.appiconwithradius)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                ScrollView {
                    Text("How To Play")
                        .font(.largeTitle)
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points!😱")
                            .padding([.horizontal, .bottom])
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal, .bottom])
                        
                        Text("If you are strugling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
                            .padding([.horizontal, .bottom])
                        
                        Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
                            .padding(.horizontal)
                        
                    }
                    .font(.title3)
                    Text("Good Luck!")
                        .font(.title)
                }
                .foregroundStyle(.black)
                
                Button("Done") {
                    dissmiss()
                }
                .doneButton()
                
            }
        }
    }
}

#Preview {
    Instructions()
}
