//
//  Comment.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation
import RealmSwift

class Comment: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var body: String?
    
    override static func primaryKey() -> String? {
      return "id"
    }
}
