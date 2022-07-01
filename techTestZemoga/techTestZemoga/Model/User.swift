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
    
    func getUserDetails() -> String {
        return "\(name ?? "")\n\(email ?? "")\n\(phone ?? "")\n\(website ?? "")"
    }
}
