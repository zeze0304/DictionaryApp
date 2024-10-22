//
//  ListDescribtionViewController.swift
//  newApp
//
//  Created by Mac on 2024/7/6.
//

import UIKit
import AVFoundation

class ListDescribtionViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var viewModel: ListDescribtionViewModel?
    let speaker = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setVC(viewModel: ListDescribtionViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.wordLabel.text = viewModel.word ?? ""
            self.partOfSpeechLabel.text = viewModel.partOfSpeech ?? ""
            self.textLabel.text = viewModel.text
        }
    }
    
    @IBAction func pronouce(_ sender: Any) {
        utterance = AVSpeechUtterance(string: wordLabel.text ?? "")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = volumeSlider.value
        speaker.speak(utterance)
    }
}
