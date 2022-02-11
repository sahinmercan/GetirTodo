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
        jobs = RealmHelper.sharedInstance.getAllJob() ?? []
        tableViewJobs.reloadData()
    }
    
    func setupXib() {
        tableViewJobs.register(UINib(nibName: JobTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: JobTableViewCell.reuseIdentifier)
    }

    @objc func addJobTapped(sender: UIBarButtonItem) {
        guard let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            return
        }
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.isEmpty ? 1 : jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JobTableViewCell.reuseIdentifier, for: indexPath) as! JobTableViewCell
        let title = jobs.isEmpty ? "Bekleyen işiniz bulunmamaktadır." : jobs[indexPath.row].title
        cell.setup(title: title)
        
        return cell
    }
}

//MARK: - UITableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateAction(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard !jobs.isEmpty else {
            return nil
        }
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
            
            if jobs.isEmpty {
                tableViewJobs.reloadRows(at: [indexPath], with: .fade)
            } else {
                tableViewJobs.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    func updateAction(indexPath: IndexPath) {
        guard !jobs.isEmpty else {
            return
        }

        guard let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
            return
        }
        detailVC.job = jobs[indexPath.row]
        detailVC.index = indexPath.row
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: DetailViewControllerDelegate {
    func detailDelete(index: Int?) {
        guard let deleteIndex = index else {
            return
        }
        
        deleteAction(indexPath: IndexPath(row: deleteIndex, section: 0))
    }
    
    func detailAddOrUpdate(job: Job, index: Int?) {
        if let updateIndex = index {
            jobs[updateIndex] = job
            tableViewJobs.reloadRows(at: [IndexPath(row: updateIndex, section: 0)], with: .fade)
        } else {
            jobs.insert(job, at: 0)
            
            if jobs.count == 1 {
                tableViewJobs.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            } else {
                tableViewJobs.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        }
    }
}
