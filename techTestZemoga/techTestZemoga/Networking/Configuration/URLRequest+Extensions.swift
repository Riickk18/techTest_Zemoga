//
//  URLRequest.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation

extension URLRequest {

    init(service: ServiceProtocol) {
        
        let urlComponents = URLComponents(service: service)
        
        self.init(url: urlComponents.url!)
        httpMethod = service.method.rawValue
        
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }

        guard case let .requestWithObject(entity) = service.task, service.parametersEncoding == .json else { return }
        
        do {
            httpBody = try entity.toJSONData()
        } catch {
            print("Encoding error", error.localizedDescription)
        }
    }
    
}

extension Encodable {
    func toJSONData() throws -> Data? {
        return try JSONEncoder().encode(self)
    }
}
