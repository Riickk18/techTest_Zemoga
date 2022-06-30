//
//  BaseViewModelProtocol.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation
import RxSwift

//MARK: - BaseViewModelProtocol
protocol BaseViewModelProtocol {
    
//    associatedtype Input
    associatedtype Output
    
    var output: Output { get }
    var error: PublishSubject<String> { get }
}
