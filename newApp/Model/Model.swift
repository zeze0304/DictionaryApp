//
//  Model.swift
//  newApp
//
//  Created by Mac on 2024/6/10.
//

import Foundation

class Vocabulary: Codable {
    var letterCount: Int?
    var word: String?
    var definitions: [Definition]

    init(letterCount: Int, word: String, definitions: [Definition]) {
        self.letterCount = letterCount
        self.word = word
        self.definitions = definitions
    }
}

class Definition: Codable {
    var text: String?
    var partOfSpeech: String?

    init(text: String, partOfSpeech: String) {
        self.text = text
        self.partOfSpeech = partOfSpeech
    }
}

enum ButtonName: String {
    case submit, next
    
    var nameString: String {
        switch self {
        case .submit:
            return "Submit"
        case . next:
            return "Next"
        }
    }
}
