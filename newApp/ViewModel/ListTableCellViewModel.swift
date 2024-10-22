//
//  ListTableCellViewModel.swift
//  newApp
//
//  Created by Mac on 2024/7/3.
//

import Foundation
class ListTableCellViewModel {
    
    var word: String?
    
    func setViewModel(response: Vocabulary) {
        self.word = response.word
    }
}
