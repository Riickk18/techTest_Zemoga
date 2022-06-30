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
        if let userFromDB = User.getUserFromDB(userId: userId) {
            user = userFromDB
        } else {
            let userFromServer = User()
            userFromServer.id = userId
            _ = User.createOrUpdate(user: userFromServer)
            user = userFromServer
        }
        title = try container.decodeIfPresent(String.self, forKey: .title)
        body = try container.decodeIfPresent(String.self, forKey: .body)
        comments = try container.decodeIfPresent(List<Comment>.self, forKey: .comments) ?? List<Comment>()
        Post.createOrUpdate(post: self)
    }
    
    public static func createOrUpdate(post: Post){
        do {
            let realm = try Realm()
            let predicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [post.id])
            let oldPost = realm.objects(Post.self).filter(predicate).first

            try realm.write {
                post.wasRead = oldPost?.wasRead ?? false
                post.isFavorite = oldPost?.isFavorite ?? false
                realm.add(post, update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public static func updateSeen(postId: Int, seen: Bool, completion: ((Post) -> Void)?){
        do {
            let realm = try Realm()
            let predicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [postId])
            guard let post = realm.objects(Post.self).filter(predicate).first else {return}

            try realm.write {
                post.wasRead = seen
                realm.add(post, update: .modified)
            }
            completion?(post)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public static func updateFavorite(postId: Int, completion: @escaping (Bool) -> Void){
        do {
            let realm = try Realm()
            let predicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [postId])
            guard let post = realm.objects(Post.self).filter(predicate).first else {return}
            try realm.write {
                post.isFavorite = !post.isFavorite
                realm.add(post, update: .modified)
            }
            completion(post.isFavorite)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public static func createOrUpdateComments(comments: [Comment], postId: Int) -> Post? {
        do {
            let realm = try Realm()
            let predicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [postId])
            guard let post = realm.objects(Post.self).filter(predicate).first else {return nil}
            let commentsList = List<Comment>()
            commentsList.append(objectsIn: comments)
            try realm.write {
                post.comments = commentsList
                realm.add([post], update: .all)
            }
            return post
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public static func deletePost(postId: Int) {
        do{
            let realm = try Realm()
            guard let post = realm.objects(Post.self).filter("id = %@", postId).first else {return}
            try realm.write{
                realm.delete(post)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
