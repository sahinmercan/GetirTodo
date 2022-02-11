//
//  JobTableViewCell.swift
//  GetirTodo
//
//  Created by sahin on 11.02.2022.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    @IBOutlet weak var labelJobTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func setup(title: String) {
        labelJobTitle.text = title
    }
}
