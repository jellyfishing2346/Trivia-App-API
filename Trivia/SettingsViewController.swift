//
//  SettingsViewController.swift
//  Trivia
//
//  Created by Faizan Khan on 3/21/25.
//

// SettingsViewController.swift
import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    var selectedCategory: Category?
    var selectedDifficulty: String = "easy"
    
    // MARK: - UI Elements
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        // Set default difficulty
        difficultySegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.categories.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = Category.categories[row]
    }
    
    // MARK: - Actions
    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedDifficulty = "easy"
        case 1:
            selectedDifficulty = "medium"
        case 2:
            selectedDifficulty = "hard"
        default:
            selectedDifficulty = "easy"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Pass selected category and difficulty back to TriviaViewController
        if let triviaVC = presentingViewController as? TriviaViewController {
            triviaVC.selectedCategory = selectedCategory
            triviaVC.selectedDifficulty = selectedDifficulty
            triviaVC.resetGame() // Restart the game with new settings
        }
        dismiss(animated: true, completion: nil)
    }
}
