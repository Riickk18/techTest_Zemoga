//
//  PostsListViewModel.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import RxSwift
import RxCocoa
import RealmSwift

class PostsListViewModel: BaseViewModelProtocol {
    
    struct Output {
        let updateTable: Observable<Bool>
        let isAnimating: Observable<Bool>
    }
    
    private let updateTableSubject: ReplaySubject<Bool> = ReplaySubject<Bool>.create(bufferSize: 1)
    private let isAnimatingSubject: ReplaySubject<Bool> = ReplaySubject<Bool>.create(bufferSize: 1)
    
    let output: Output
    internal var error: PublishSubject<String> = PublishSubject()
    var onShowInfoAlert : ((_ message: String,_ title: String?) -> Void)?

    var cells: [PostViewModel] = []

    init() {
        output = Output(updateTable: updateTableSubject.asObservable(), isAnimating: isAnimatingSubject.asObservable())
    }
    
    func getPostsFromDb() {
        do {
            let realm = try Realm()
            let posts = realm.objects(Post.self)
            cells = posts.sorted(by: { $0.isFavorite && !$1.isFavorite}).map({ PostViewModel(with: $0) })
            updateTableSubject.onNext(true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getPosts(){
        let sessionProvider = URLSessionProvider()
        isAnimatingSubject.onNext(true)
        sessionProvider.request(type: [Post].self, service: PostService.getPostsFromApi) { [weak self] response in
            self?.isAnimatingSubject.onNext(false)
            switch response{
            case .success(let posts):
                self?.buildPostsModels(posts)
            case .failure(let error):
                self?.onShowInfoAlert?(error.rawValue, nil)
            }
        }
    }
    
    private func buildPostsModels(_ posts: [Post]) {
        posts.forEach { post in
            Post.createOrUpdate(post: post)
        }
        cells = posts.sorted(by: { $0.isFavorite && !$1.isFavorite}).map({ PostViewModel(with: $0) })
        updateTableSubject.onNext(true)
    }
    
    func deleteAllPosts() {
        do{
            let realm = try Realm()
            let posts = realm.objects(Post.self)
            try posts.forEach({ post in
                try realm.write{
                    realm.delete(post)
                }
            })
            self.cells = []
            self.updateTableSubject.onNext(true)
        }catch{
            print(error.localizedDescription)
        }
    }
}
