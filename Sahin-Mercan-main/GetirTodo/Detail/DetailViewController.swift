//
//  DetailViewController.swift
//  GetirTodo
//
//  Created by sahin on 11.02.2022.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailAddOrUpdate(job: Job, index: Int?)
    func detailDelete(index: Int?)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var tableViewJobDetail: UITableView!
    
    //MARK: Variables
    weak var delegate: DetailViewControllerDelegate?
    let notificationCenter = NotificationCenter.default
    var job: Job?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    

    func setup() {
        if job != nil {
            self.title = "İş Detayı"
        } else {
            self.title = "İş Ekle"
        }

        addKeyboardNotifications()
        setupXib()
    }

    //MARK: - Keyboard Notifications and Handlers
    func addKeyboardNotifications() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShowHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHideHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowHandler(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        tableViewJobDetail.contentInset.bottom = keyboardSize.height
        tableViewJobDetail.scrollIndicatorInsets.bottom = keyboardSize.height
    }
    
    @objc func keyboardWillHideHandler(_ notification: Notification) {
        tableViewJobDetail.contentInset.bottom = 0
        tableViewJobDetail.scrollIndicatorInsets.bottom = 0
    }
    
    func setupXib() {
        tableViewJobDetail.register(UINib(nibName: DetailTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailTableViewCell.reuseIdentifier)
        tableViewJobDetail.reloadData()
    }
}


extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as! DetailTableViewCell
        cell.setup(job: job)
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableView Delegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewController: DetailTableViewCellDelegate {
    func clickedToDelete() {
        navigationController?.popViewController(animated: true)
        delegate?.detailDelete(index: index)
    }
    
    func clickedToSend(title: String, content: String) {
        if let updateJob = job {
            let realmJob = RealmHelper.sharedInstance.updateJob(jobId: updateJob._id, title: title, content: content)
            
            if let changeJob = realmJob {
                navigationController?.popViewController(animated: true)
                delegate?.detailAddOrUpdate(job: changeJob, index: index)
            }
        } else {
            let newJob = RealmHelper.sharedInstance.createJob(title: title, content: content)

            if let addJob = newJob {
                navigationController?.popViewController(animated: true)
                delegate?.detailAddOrUpdate(job: addJob, index: index)
            }
        }
    }
}
