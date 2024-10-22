//
//  ListDescribtionViewModel.swift
//  newApp
//
//  Created by Mac on 2024/7/7.
//

import Foundation
class ListDescribtionViewModel {
    
    var word: String?
    var partOfSpeech: String?
    var text: String?
    
    func setViewModel(response: Vocabulary?) {
        self.word = response?.word ?? ""
        self.partOfSpeech = response?.definitions.first?.partOfSpeech ?? ""
        self.text = response?.definitions.first?.text ?? ""
    }
}
