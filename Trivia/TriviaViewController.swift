//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

// TriviaViewController.swift
import UIKit

class TriviaViewController: UIViewController {
  
    // MARK: - Outlets
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    // MARK: - Properties
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    var selectedCategory: Category?
    var selectedDifficulty: String = "easy"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        fetchTriviaQuestions() // Fetch questions here
    }
    
    // TriviaViewController.swift
    internal func resetGame() {
        print("Resetting game...")
        currQuestionIndex = 0
        numCorrectQuestions = 0
        questions.removeAll()
        fetchTriviaQuestions()
        updateQuestion(withQuestionIndex: currQuestionIndex)
        resetButtons()
    }
    
    // MARK: - Fetch Questions
    private func fetchTriviaQuestions() {
        var urlString = "https://opentdb.com/api.php?amount=5&type=multiple"
        if let category = selectedCategory {
            urlString += "&category=\(category.id)"
        }
        urlString += "&difficulty=\(selectedDifficulty)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error fetching questions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    self.questions = results.compactMap { TriviaQuestion(json: $0) }
                    DispatchQueue.main.async {
                        self.updateQuestion(withQuestionIndex: 0)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // MARK: - Update UI
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        // Ensure questions array is not empty
        guard !questions.isEmpty else {
            print("Error: Questions array is empty")
            return
        }
        
        // Ensure questionIndex is within bounds
        guard questionIndex >= 0, questionIndex < questions.count else {
            print("Error: questionIndex (\(questionIndex)) is out of bounds for questions array (count: \(questions.count))")
            return
        }
        
        // Safely unwrap the question
        let question = questions[questionIndex]
        
        // Update UI
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
        questionLabel.text = question.question.decodedHTMLString // Decode HTML entities
        categoryLabel.text = question.category
        
        let answers: [String]
        if question.type == "boolean" {
            answers = ["True", "False"]
        } else {
            answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        }
        
        // Set button titles
        answerButton0.setTitle(answers[0], for: .normal)
        answerButton1.setTitle(answers[1], for: .normal)
        answerButton2.setTitle(answers.count > 2 ? answers[2] : "", for: .normal)
        answerButton3.setTitle(answers.count > 3 ? answers[3] : "", for: .normal)
        
        // Hide unused buttons for true/false questions
        answerButton2.isHidden = question.type == "boolean" || answers.count <= 2
        answerButton3.isHidden = question.type == "boolean" || answers.count <= 3
    }
    
    // MARK: - Game Logic
    private func updateToNextQuestion(answer: String) {
        disableButtons()
        highlightAnswers(selectedAnswer: answer)
        
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.currQuestionIndex += 1
            if self.currQuestionIndex < self.questions.count {
                self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
                self.resetButtons()
            } else {
                self.showFinalScore()
            }
        }
    }
    
    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }
    
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            self.resetGame()
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - UI Helpers
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func disableButtons() {
        answerButton0.isEnabled = false
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
    }
    
    private func highlightAnswers(selectedAnswer: String) {
        // Ensure questions array is not empty
        guard !questions.isEmpty else {
            print("Error: Questions array is empty")
            return
        }
        
        // Ensure currQuestionIndex is within bounds
        guard currQuestionIndex >= 0, currQuestionIndex < questions.count else {
            print("Error: currQuestionIndex (\(currQuestionIndex)) is out of bounds for questions array (count: \(questions.count))")
            return
        }
        
        // Safely access the correct answer
        let correctAnswer = questions[currQuestionIndex].correctAnswer
        
        // Highlight the correct and selected answers
        let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]
        for button in buttons {
            if button?.titleLabel?.text == correctAnswer {
                button?.backgroundColor = .green
            } else if button?.titleLabel?.text == selectedAnswer {
                button?.backgroundColor = .red
            }
        }
    }
    
    private func resetButtons() {
        let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]
        for button in buttons {
            button?.isEnabled = true
            button?.backgroundColor = .systemBlue
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}
