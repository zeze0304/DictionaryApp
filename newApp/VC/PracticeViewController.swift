//
//  PracticeViewController.swift
//  newApp
//
//  Created by Mac on 2024/7/11.
//

import UIKit
import AVFoundation

class PracticeViewController: UIViewController {
    
    @IBOutlet weak var bottomLineLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var vocabularyLabel: UILabel!
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var correctImageView: UIImageView!
    
    let urlStrings = [ "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/1%E7%B4%9A.json","https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/2%E7%B4%9A.json","https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/3%E7%B4%9A.json","https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/4%E7%B4%9A.json","https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/5%E7%B4%9A.json","https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/6%E7%B4%9A.json"]
    
    var urlString = "https://raw.githubusercontent.com/AppPeterPan/TaiwanSchoolEnglishVocabulary/main/1%E7%B4%9A.json"
    
    var vocabulary = [Vocabulary]()
    var letterCount = 0
    var inputLetterCount = 0
    let speaker = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        submitButton.setTitle(ButtonName.submit.nameString, for: .normal)
        setupInputTextField()
    }
    
    fileprivate func updateUI() {
        
        let url = URL(string: urlString)
        if let url {
            URLSession.shared.dataTask(with: url) {
                data, urlRequest, error in
                let decoder = JSONDecoder()
                if let data {
                    do {
                        self.vocabulary = try decoder.decode([Vocabulary].self, from: data)
                        DispatchQueue.main.async {
                            
                            let index = Int.random(in: 0..<self.vocabulary.count)
                            self.vocabularyLabel.text = self.vocabulary[index].word
                            self.partOfSpeechLabel.text = self.vocabulary[index].definitions[0].partOfSpeech
                            self.chineseLabel.text = self.vocabulary[index].definitions[0].text
                            self.letterCount = self.vocabulary[index].letterCount ?? 0
                            self.setBlankLabel()
                            self.vocabularyLabel.isHidden = true
                            self.correctImageView.isHidden = true
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func setupInputTextField() {
            inputTextField.borderStyle = .none
            inputTextField.backgroundColor = .clear
            inputTextField.textColor = .clear // 使文字透明
            inputTextField.tintColor = .clear // 使光標透明
            
            // 設置等寬字體
            if let font = UIFont(name: "Courier", size: bottomLineLabel.font.pointSize) {
                inputTextField.font = font
                bottomLineLabel.font = font
            }
            
            // 添加 editing changed 事件
            inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateBottomLineLabel(withText: textField.text ?? "")
    }
    
    func updateBottomLineLabel(withText text: String) {
        let spacer = " "
        let underscore = "_"
        var newBottomText = ""
        
        for i in 0..<letterCount {
            if i < text.count {
                newBottomText += String(text[text.index(text.startIndex, offsetBy: i)])
            } else {
                newBottomText += underscore
            }
            
            // 在每個字符後添加一個空格，除了最後一個
            if i < letterCount - 1 {
                newBottomText += spacer
            }
        }
        
        bottomLineLabel.text = newBottomText
    }
    
    fileprivate func setBlankLabel() {
        var blankField = ""
        for _ in 1...self.letterCount {
            blankField += " _"
        }
        self.bottomLineLabel.text = blankField
    }
    
    fileprivate func resetQuestion() {
        inputTextField.text = ""
        vocabularyLabel.isHidden = true
        setBlankLabel()
        bottomLineLabel.isHidden = false
        submitButton.setTitle(ButtonName.submit.nameString, for: .normal)
        showAnswerButton.isHidden = false
        inputTextField.becomeFirstResponder()
        correctImageView.isHidden = true
    }
    
    @IBAction func onTouchCheckButton(_ sender: UIButton) {
        
        switch sender.currentTitle {
            
        case ButtonName.submit.nameString:
            print("correct")
            if inputTextField.text == vocabularyLabel.text {
                bottomLineLabel.isHidden = true
                showAnswerButton.isHidden = true
                sender.setTitle(ButtonName.next.nameString, for: .normal)
                inputTextField.resignFirstResponder()
                correctImageView.isHidden = false
            } else {
                print("incorrect")
                UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .repeat], animations: {
                    self.bottomLineLabel.transform = CGAffineTransform(translationX: -8, y: 0)
                },completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.bottomLineLabel.layer.removeAllAnimations()
                }
                bottomLineLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                
                Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                    self.setBlankLabel()
                }
                inputTextField.text = ""
                correctImageView.isHidden = true
            }
            
        case ButtonName.next.nameString:
            print("next question")
            updateUI()
            resetQuestion()
            
        case .none:
            print("none")
            
        case .some(_):
            print("none")
        }
    }
    
    @IBAction func input(_ sender: UITextField) {
        if let text = sender.text {
            inputLetterCount = text.count
        }

        let remainingBottomLine = letterCount - inputLetterCount
        if remainingBottomLine > 0 {
            var blankField = ""
            for _ in 1...remainingBottomLine {
                blankField += " _"

            }
            print("blankField",blankField)
            bottomLineLabel.text = (sender.text ?? "") + blankField
        } else {
            bottomLineLabel.text = (sender.text ?? "")
        }
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        inputTextField.resignFirstResponder()
        bottomLineLabel.isHidden = true
        showAnswerButton.isHidden = true
        vocabularyLabel.isHidden = false
        submitButton.setTitle(ButtonName.next.nameString, for: .normal)
    }
    
    @IBAction func selectLevel(_ sender: UISegmentedControl) {
        urlString = urlStrings[sender.selectedSegmentIndex]
        updateUI()
        resetQuestion()
    }
    
    @IBAction func pronouce(_ sender: Any) {
        utterance = AVSpeechUtterance(string: vocabularyLabel.text ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speaker.speak(utterance)
    }
}
