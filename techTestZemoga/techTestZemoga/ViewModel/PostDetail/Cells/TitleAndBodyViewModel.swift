//
//  TitleAndBodyViewModel.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

import RxSwift
import RxCocoa

class TitleAndDescriptionViewModel: BaseViewModelProtocol {
    struct Output {
        let title: Driver<String>
        let body: Driver<String>
    }
    
    private let titleSubject: ReplaySubject<String> = ReplaySubject<String>.create(bufferSize: 1)
    private let bodySubject: ReplaySubject<String> = ReplaySubject<String>.create(bufferSize: 1)
    
    let output: Output
    internal var error: PublishSubject<String> = PublishSubject()
    var onShowInfoAlert : ((_ message: String,_ title: String?) -> Void)?

    var title: String?
    var body: String?
    
    init(title: String? = nil, body: String? = nil) {
        output = Output(title: titleSubject.asDriver(onErrorJustReturn: ""), body: bodySubject.asDriver(onErrorJustReturn: ""))
        titleSubject.onNext(title ?? "")
        bodySubject.onNext(body ?? "")
    }
}
