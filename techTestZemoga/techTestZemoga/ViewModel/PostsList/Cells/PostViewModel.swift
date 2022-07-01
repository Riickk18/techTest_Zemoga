//
//  PostViewModel.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import RxSwift
import RxCocoa

class PostViewModel: BaseViewModelProtocol {
    struct Output {
        let title: Driver<String>
        let status: Observable<(read: Bool, favorite: Bool)>
    }
    
    let output: Output
    internal var error: PublishSubject<String> = PublishSubject()
    var post: Post?
    var postId: Int?
    
    private let titleSubject: ReplaySubject<String> = ReplaySubject<String>.create(bufferSize: 1)
    private let statusSubject: ReplaySubject<(read: Bool, favorite: Bool)> = ReplaySubject<(read: Bool, favorite: Bool)>.create(bufferSize: 1)
    
    init(with post: Post){
        self.post = post
        self.postId = post.id
        output = Output(title: titleSubject.asDriver(onErrorJustReturn: ""),
                        status: statusSubject.asObservable()
        )
        initSubjects()
    }
    
    private func initSubjects() {
        guard let post = post else {
            return
        }

        titleSubject.onNext(post.title ?? "")
        statusSubject.onNext((read: post.wasRead, favorite: post.isFavorite))
    }
    
    func updateStateToSeen(postId: Int) {
        RealmHelper.post(updateSeenWithPostId: postId, seen: true) { post in
            self.post = post
            self.initSubjects()
        }
    }
}
