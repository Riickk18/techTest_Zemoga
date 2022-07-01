//
//  RealmHelper.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 7/1/22.
//

import Foundation
import RealmSwift

class RealmHelper {
    static let shared = RealmHelper()
    
    // MARK: - Post methos
    static func getPostsFromDb(completion: ([Post]) -> Void){
        do {
            let realm = try Realm()
            let posts = realm.objects(Post.self)
            completion(Array(posts))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func deleteAllPosts(completion: @escaping () -> Void) {
        do{
            let realm = try Realm()
            let posts = realm.objects(Post.self)
            try posts.forEach({ post in
                try realm.write{
                    realm.delete(post)
                }
            })
            completion()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    static func post(createOrUpdate post: Post){
        do {
            let realm = try Realm()
            let predicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [post.id])
            let oldPost = realm.objects(Post.self).filter(predicate).first

            try realm.write {
                if let oldPost = oldPost {
                    post.wasRead = oldPost.wasRead
                    post.isFavorite = oldPost.isFavorite
                }
                realm.add(post, update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func post(getPostById postId: Int, completion: (Post) -> Void) {
        do {
            let realm = try Realm()
            let postPredicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [postId])
            guard let post = realm.objects(Post.self).filter(postPredicate).first else {return}
            completion(post)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func post(updatePostSeen postId: Int) {
        do {
            let realm = try Realm()
            let postPredicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [postId])
            guard let post = realm.objects(Post.self).filter(postPredicate).first else {return}
            try! realm.write {
                post.wasRead = true
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func post(updateSeenWithPostId postId: Int, seen: Bool, completion: ((Post) -> Void)?){
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
    
    static func post(updateFavoriteWithPostId postId: Int, completion: @escaping (Bool) -> Void){
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
    
    static func post(createOrUpdateComments comments: [Comment], postId: Int) -> Post? {
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
    
    static func post(deletePostWithId postId: Int) {
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
    
    // MARK: - User methods
    static func user(createOrUpdate user: User) -> (Bool, String?){
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
    
    static func user(getUserFromDBWithId userId: Int) -> (User?){
        do {
            let realm = try Realm()
            let postPredicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [userId])
            return realm.objects(User.self).filter(postPredicate).first
        } catch {
            return nil
        }
    }
}
