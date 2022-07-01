//
//  Post.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation
import RealmSwift

class Post: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var user: User?
    @objc dynamic var title: String?
    @objc dynamic var body: String?
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var wasRead: Bool = false

    var comments = List<Comment>()
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case body
        case isFavorite
        case wasRead
        case comments
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        if let userFromDB = RealmHelper.user(getUserFromDBWithId: userId) {
            user = userFromDB
        } else {
            let userFromServer = User()
            userFromServer.id = userId
            _ = RealmHelper.user(createOrUpdate: userFromServer)
            user = userFromServer
        }
        title = try container.decodeIfPresent(String.self, forKey: .title)
        body = try container.decodeIfPresent(String.self, forKey: .body)
        comments = try container.decodeIfPresent(List<Comment>.self, forKey: .comments) ?? List<Comment>()
        RealmHelper.post(createOrUpdate: self)
    }

    

}
