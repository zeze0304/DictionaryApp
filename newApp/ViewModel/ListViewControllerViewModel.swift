//
//  ViewModel.swift
//  newApp
//
//  Created by Mac on 2024/6/10.
//

import Foundation

class ListViewControllerViewModel {
    
    var listTableCellViewModels: [ListTableCellViewModel] = []
    var listDescribtionViewModels: [ListDescribtionViewModel] = []
    
    func setViewModel(response: [Vocabulary]) {
        
        listTableCellViewModels.removeAll()
        listDescribtionViewModels.removeAll()
        
        response.forEach { word in
            let cellViewModel = ListTableCellViewModel()
            cellViewModel.setViewModel(response: word)
            listTableCellViewModels.append(cellViewModel)
            
            let describtionViewModel = ListDescribtionViewModel()
            describtionViewModel.setViewModel(response: word)
            listDescribtionViewModels.append(describtionViewModel)
        }
    }
}
