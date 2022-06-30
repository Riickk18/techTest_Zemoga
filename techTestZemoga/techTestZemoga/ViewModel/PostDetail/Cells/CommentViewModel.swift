//
//  CommentViewModel.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import RxSwift
import RxCocoa

class CommentViewModel: BaseViewModelProtocol {
    struct Output {
        let comment: Driver<NSAttributedString>
        let email: Driver<String>
    }
    
    private let commentSubject: ReplaySubject<NSAttributedString> = ReplaySubject<NSAttributedString>.create(bufferSize: 1)
    private let emailSubject: ReplaySubject<String> = ReplaySubject<String>.create(bufferSize: 1)
    
    let output: Output
    internal var error: PublishSubject<String> = PublishSubject()
    var onShowInfoAlert : ((_ message: String,_ title: String?) -> Void)?

    var comment: Comment?
    
    init(with comment: Comment?) {
        output = Output(comment: commentSubject.asDriver(onErrorJustReturn: NSAttributedString(string: "")), email: emailSubject.asDriver(onErrorJustReturn: ""))
        let name = comment?.name ?? ""
        let body = comment?.body ?? ""
        commentSubject.onNext(body.configureMutableString(stringBold: "\(name) ", size: 14))
        emailSubject.onNext(comment?.email ?? "")
    }
}

