//
//  NetworkResponse.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation

enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
