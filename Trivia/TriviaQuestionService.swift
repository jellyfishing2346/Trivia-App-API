//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Test on 3/21/25.
//

// TriviaQuestionService.swift
import Foundation

class TriviaQuestionService {
    static func fetchQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let url = URL(string: "https://opentdb.com/api.php?amount=5&type=multiple")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching questions: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    let questions = results.compactMap { TriviaQuestion(json: $0) }
                    completion(questions)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
