//
//  PostDetailViewModel.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import RxSwift
import RxCocoa

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
        RealmHelper.post(updatePostSeen: postId ?? 0)
        RealmHelper.post(getPostById: postId ?? 0) { [weak self] updatedPost in
            self?.post = updatedPost
            self?.dataCells.append(TitleAndDescriptionViewModel(title: updatedPost.title, body: updatedPost.body))
            self?.dataCells.append(TitleAndDescriptionViewModel(title: "User", body: updatedPost.user?.getUserDetails()))
            self?.favoriteIconSubject.onNext(updatedPost.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))
            self?.updateTableSubject.onNext(true)
        }
    }
    
    func getUserData() {
        let sessionProvider = URLSessionProvider()
        isAnimatingSubject.onNext(true)
        sessionProvider.request(type: User.self, service: UserService.getUserDetails(post?.user?.id ?? 0)) { [weak self] response in
            self?.isAnimatingSubject.onNext(false)
            switch response{
            case .success(let user):
                _ = RealmHelper.user(createOrUpdate: user)
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
        RealmHelper.post(updateFavoriteWithPostId: postId ?? 0) { [weak self] isFavorite in
            self?.favoriteIconSubject.onNext(isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"))
        }
    }
    
    func deletePost(completion: @escaping () -> Void) {
        guard let postId = postId else {
            return
        }
        RealmHelper.post(deletePostWithId: postId)
        completion()
    }
}
