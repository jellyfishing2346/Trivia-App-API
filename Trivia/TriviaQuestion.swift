//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let type: String // "multiple" or "boolean"
    
    init?(json: [String: Any]) {
        guard let category = json["category"] as? String,
              let question = json["question"] as? String,
              let correctAnswer = json["correct_answer"] as? String,
              let incorrectAnswers = json["incorrect_answers"] as? [String],
              let type = json["type"] as? String else {
            return nil
        }
        self.category = category
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.type = type
    }
}
