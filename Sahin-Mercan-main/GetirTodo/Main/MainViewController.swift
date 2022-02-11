//
//  MainViewController.swift
//  GetirTodo
//
//  Created by sahin on 11.02.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableViewJobs: UITableView!
    
    //MARK: Variables
    var jobs: [Job] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    

    func setup() {
        self.title = "İşler"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ekle", style: .done, target: self, action: #selector(addJobTapped))
        setupXib()
    }
    
    func setupXib() {
        tableViewJobs.register(UINib(nibName: JobTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: JobTableViewCell.reuseIdentifier)
        tableViewJobs.reloadData()
    }

    @objc func addJobTapped(sender: UIBarButtonItem) {
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.reuseIdentifier, for: indexPath) as! JobTableViewCell
        cell.setup(title: jobs[indexPath.row].title)
        
        return cell
    }
}

//MARK: - UITableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Sil") { [weak self] (action, indexPath) in
            self?.deleteAction(indexPath: indexPath)
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Düzenle") { [weak self] (action, indexPath) in
            self?.updateAction(indexPath: indexPath)
        }
        
        delete.backgroundColor = .red
        share.backgroundColor = .blue
        
        return [delete, share]
    }

    func deleteAction(indexPath: IndexPath) {
        let result = RealmHelper.sharedInstance.deleteJob(jobId: jobs[indexPath.row]._id)
        
        if result {
            jobs.remove(at: indexPath.row)
            tableViewJobs.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func updateAction(indexPath: IndexPath) {
        
    }
}
