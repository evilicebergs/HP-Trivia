//
//  Game.swift
//  HP Trivia
//
//  Created by Artem Golovchenko on 2024-10-21.
//

import Foundation

@MainActor
class Game: ObservableObject {
    private var allQuestions: [Question] = []
    private var answeredQuestions: [Int] = []
    
    var filteredQuestons: [Question] = []
    var currentQuestion = Constants.previewQuestion
    
    init() {
        decodeQuestions()
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
