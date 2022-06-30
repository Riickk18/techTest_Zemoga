//
//  NetworkError.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation

enum NetworkError: String, CaseIterable {
    case unknown = "An unknown error has occurred, please try again later."
    case serverOutOfLine = "We can't communicate to our server"
    case noJSONData = "We can't communicate to our server, please try again later."
    case decodeError = "We have problems to process your request, please try again later."
    case networkError = "A network error has occurred, please check your internet connection and try again."
}
