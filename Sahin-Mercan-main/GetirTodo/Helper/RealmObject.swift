//
//  RealmObject.swift
//  GetirTodo
//
//  Created by sahin on 11.02.2022.
//

import RealmSwift

final class Job: Object {
    @objc dynamic var _id: String = ObjectId.generate().stringValue
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var timestamp: TimeInterval = Date().timeIntervalSince1970
    
    override class func primaryKey() -> String? {
        return "_id"
    }
}
