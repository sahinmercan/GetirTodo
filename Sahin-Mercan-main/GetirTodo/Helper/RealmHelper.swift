//
//  RealmHelper.swift
//  GetirTodo
//
//  Created by sahin on 11.02.2022.
//

import RealmSwift

class RealmHelper {

    //MARK: - Singleton
    fileprivate static var _sharedInstance: RealmHelper?
    
    static var sharedInstance: RealmHelper {
        if _sharedInstance == nil {
            _sharedInstance = RealmHelper()
        }
        return _sharedInstance!
    }

    static func reset() {
        _sharedInstance = nil
    }
}

//MARK: - Job CRUD işlemleri
extension RealmHelper {
    func createJob(title: String, content: String) -> Bool {
        let job = Job()
        job.title = title
        job.content = content
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(job)
            }
            debugPrint("========CREATE JOB========")
            debugPrint(job)
            
            return true
        } catch let error {
            debugPrint(error)
            return false
        }
    }

    func updateJob(jobId: String, title: String, content: String) -> Bool {
        guard let job: Job = getSelectJob(id: jobId) else {
            return false
        }
        
        do {
            let realm = try Realm()
            
            try realm.write {
                job.setValue(title, forKey: "title")
                job.setValue(content, forKey: "content")
                job.setValue(Date().timeIntervalSince1970, forKey: "timestamp")
            }
            debugPrint("========UPDATE JOB========")
            debugPrint(job)
            
            
            return true
        } catch let error {
            debugPrint(error)
            return false
        }
    }

    func deleteJob(jobId: String) -> Bool {
        guard let job: Job = getSelectJob(id: jobId) else {
            return false
        }
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(job)
            }
            debugPrint("========DELETE JOB========")
            debugPrint(job)
            
            return true
        } catch let error {
            debugPrint(error)
            return false
        }
    }

    func getAllJob() -> [Job]? {
        var jobs: Results<Job>? = nil

        do {
            let realm = try Realm()
            
            jobs = realm.objects(Job.self).sorted(byKeyPath: "timestamp", ascending: false)
            let jobsWrapped: [Job]? = jobs?.enumerated().map { _, item in
                return item
            }
            
            debugPrint("========ALL JOB========")
            debugPrint(jobs ?? "nil")
            
            return jobsWrapped
        } catch let error {
            debugPrint(error)
        }
        
        return []
    }

    func getSelectJob(id: String) -> Job? {
        var jobs: Results<Job>? = nil

        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "_id == %@", "\(id)")
            jobs = realm.objects(Job.self).filter(predicate)
            
        } catch let error {
            debugPrint(error)
        }
        
        debugPrint("========SELECT JOB========")
        debugPrint(jobs?.first ?? "")
        
        return jobs?.first
    }
}
