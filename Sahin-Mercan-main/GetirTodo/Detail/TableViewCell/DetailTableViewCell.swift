//
//  DetailTableViewCell.swift
//  GetirTodo
//
//  Created by sahin on 11.02.2022.
//

import UIKit

protocol DetailTableViewCellDelegate: AnyObject {
    func clickedToSend(title: String, content: String)
    func clickedToDelete()
}

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textfieldTitle: UITextField!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    //MARK: Variables
    weak var delegate: DetailTableViewCellDelegate?
    var toolBar = UIToolbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func setup(job: Job?) {
        labelTitle.text = "Başlık"
        labelContent.text = "Detay"
        let sendText = job != nil ? "Güncelle" : "Ekle"
        buttonSend.setTitle(sendText, for: .normal)
        buttonDelete.setTitle("Sil", for: .normal)
        buttonDelete.isHidden = job == nil
        textfieldTitle.text = job?.title ?? ""
        textViewContent.text = job?.content ?? ""
        setupToolBar()
    }

    @IBAction func clickedSend(_ sender: UIButton) {
        let title = textfieldTitle.text ?? ""
        let content = textViewContent.text ?? ""
        
        if !title.isEmpty && !content.isEmpty {
            delegate?.clickedToSend(title: title, content: content)
        }
    }

    @IBAction func clickedDelete(_ sender: UIButton) {
        delegate?.clickedToDelete()
    }
}

extension DetailTableViewCell {
    func setupToolBar() {
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let closeButton = UIBarButtonItem(title: "Kapat", style: .plain, target: self, action: #selector(clickedToCloseButtonOnPickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([closeButton, spaceButton], animated: false)
        
        textfieldTitle.inputAccessoryView = toolBar
        textViewContent.inputAccessoryView = toolBar
    }
    
    @objc func clickedToCloseButtonOnPickerView() {
        textfieldTitle.resignFirstResponder()
        textViewContent.resignFirstResponder()
    }
}
