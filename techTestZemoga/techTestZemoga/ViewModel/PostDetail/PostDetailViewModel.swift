//
//  PostDetailViewModel.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import RxSwift
import RxCocoa
import RealmSwift

class PostDetailViewModel: BaseViewModelProtocol {
    
    struct Output {
        let updateTable: Observable<Bool>
        let isAnimating: Observable<Bool>
        let favoriteIcon: Observable<UIImage?>
    }
    
    private let updateTableSubject: ReplaySubject<Bool> = ReplaySubject<Bool>.create(bufferSize: 1)
    private let isAnimatingSubject: ReplaySubject<Bool> = ReplaySubject<Bool>.create(bufferSize: 1)
    private let favoriteIconSubject: ReplaySubject<UIImage?> = ReplaySubject<UIImage?>.create(bufferSize: 1)

    let output: Output
    internal var error: PublishSubject<String> = PublishSubject()
    var onShowInfoAlert : ((_ message: String,_ title: String?) -> Void)?

    var dataCells: [TitleAndDescriptionViewModel] = []
    var commentsCells: [CommentViewModel] = []
    var postId: Int?
    var post: Post?

    init(postId: Int?) {
        self.postId = postId
        output = Output(updateTable: updateTableSubject.asObservable(), isAnimating: isAnimatingSubject.asObservable(), favoriteIcon: favoriteIconSubject.asObservable())
    }
    
    func initCells() {
        dataCells = []
        do {
            let realm = try Realm()
            let postPredicate: NSPredicate = NSPredicate(format: "id = %@", argumentArray: [postId ?? 0])
            guard let post = realm.objects(Post.self).filter(postPredicate).first else {return}
            try! realm.write {
                post.wasRead = true
            }
            self.post = post
            self.dataCells.append(TitleAndDescriptionViewModel(title: post.title, body: post.body))
            self.dataCells.append(TitleAndDescriptionViewModel(title: "User", body: post.user?.getUserDetails()))
            self.favoriteIconSubject.onNext(post.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))
            self.updateTableSubject.onNext(true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getUserData() {
        let sessionProvider = URLSessionProvider()
        isAnimatingSubject.onNext(true)
        sessionProvider.request(type: User.self, service: UserService.getUserDetails(post?.user?.id ?? 0)) { [weak self] response in
            self?.isAnimatingSubject.onNext(false)
            switch response{
            case .success(let user):
                _ = User.createOrUpdate(user: user)
                self?.getComments()
            case .failure(let error):
                self?.onShowInfoAlert?(error.rawValue, nil)
            }
        }

    }
    
    func getComments(){
        let sessionProvider = URLSessionProvider()
        isAnimatingSubject.onNext(true)
        sessionProvider.request(type: [Comment].self, service: PostService.getComments(postId ?? 0)) { [weak self] response in
            self?.isAnimatingSubject.onNext(false)
            switch response{
            case .success(let comments):
                self?.buildCommentsModels(comments)
            case .failure(let error):
                self?.onShowInfoAlert?(error.rawValue, nil)
            }
        }
    }
    
    private func buildCommentsModels(_ comments: [Comment]) {
        commentsCells = comments.map({ CommentViewModel(with: $0) })
        initCells()
    }
    
    func updateFavoriteStatus() {
        Post.updateFavorite(postId: postId ?? 0) { [weak self] isFavorite in
            self?.favoriteIconSubject.onNext(isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))
        }
    }
    
    func deletePost(completion: @escaping () -> Void) {
        guard let postId = postId else {
            return
        }
        Post.deletePost(postId: postId)
        completion()
    }
}
