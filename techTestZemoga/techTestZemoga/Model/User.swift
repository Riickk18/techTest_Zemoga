//
//  User.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation
import RealmSwift

class User: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var phone: String?
    @objc dynamic var website: String?
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
    public static func createOrUpdate(user: User) -> (Bool, String?){
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(user, update: .modified)
            }
            return (true, nil)
        } catch let error {
            return (false, error.localizedDescription)
        }
    }
    
    public static func getUserFromDB(userId: Int) -> (User?){
        do {
            let realm = try Realm()
            let postPredicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [userId])
            return realm.objects(User.self).filter(postPredicate).first
        } catch {
            return nil
        }
    }
    
    func getUserDetails() -> String {
        return "\(name ?? "")\n\(email ?? "")\n\(phone ?? "")\n\(website ?? "")"
    }
}
