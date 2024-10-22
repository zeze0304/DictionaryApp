//
//  ListTableViewCell.swift
//  newApp
//
//  Created by Mac on 2024/6/16.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func presentViewController()
}
 
class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    
    weak var delegate: ListTableViewCellDelegate?
    var viewModel: ListTableCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel = ListTableCellViewModel()
    }
    
    func setCell(viewModel: ListTableCellViewModel) {
        self.wordLabel.text = viewModel.word ?? ""
    }
}
