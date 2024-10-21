//
//  Game.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-21.
//

import Foundation

@MainActor
class Game: ObservableObject {
    @Published var gameScore = 0
    @Published var questionScore = 5
    @Published var recentScores = [0, 0, 0]
    
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = []
    
    var filteredQuestons: [Question] = []
    var currentQuestion = Constants.previewQuestion
    var answers: [String] = []
    
    var correctAnswer: String {
        currentQuestion.answers.first(where: { $0.value == true })!.key
    }
    
    init() {
        decodeQuestions()
    }
    
    func startGame() {
        gameScore = 0
        questionScore = 5
        answeredQuestions = []
        
        
    }
    
    func filterQuestions(to books: [Int]) {
        filteredQuestons = allQuestions.filter { books.contains($0.book) }
    }
    
    func newQuestion() {
        if filteredQuestons.isEmpty {
            return
        }
        
        if answeredQuestions.count == filteredQuestons.count {
            answeredQuestions = []
        }
        
        var potentialQuestion = filteredQuestons.randomElement()!
        while answeredQuestions.contains(potentialQuestion.id) {
            potentialQuestion = filteredQuestons.randomElement()!
        }
        currentQuestion = potentialQuestion
        
        answers = []
        
        for answer in currentQuestion.answers.keys {
            answers.append(answer)
        }
        
        answers.shuffle()
        
        questionScore = 5
    }
    
    func correct() {
        answeredQuestions.append(currentQuestion.id)
        
        gameScore += questionScore
    }
    
    func endGame() {
        recentScores[2] = recentScores[1]
        recentScores[1] = recentScores [0]
        recentScores[0] = gameScore
    }
    
    private func decodeQuestions() {
        if let url = Bundle.main.url(forResource: "trivia", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                allQuestions = try decoder.decode([Question].self, from: data)
                filteredQuestons = allQuestions
            } catch {
                print("Some error with decoding: \(error)")
            }
            
        }
    }
}
