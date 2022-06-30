//
//  URLComponents.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation

extension URLComponents {

    init(service: ServiceProtocol) {
        let serverUrl: String = "https://jsonplaceholder.typicode.com/"
        let url = URL(string: serverUrl + service.path)
        
        self.init(url: url!, resolvingAgainstBaseURL: false)!
        
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else { return }
        
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
