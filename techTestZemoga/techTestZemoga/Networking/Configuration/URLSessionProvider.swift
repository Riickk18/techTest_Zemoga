//
//  URLSessionProvider.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/29/22.
//

import Foundation

protocol URLSessionProviderProgressDelegate: AnyObject {
    func progress(value: Double)
}

final class URLSessionProvider: ProviderProtocol {
    
    private var session: URLSessionProtocol
    private var task: URLSessionTask?
    private var observation: NSKeyValueObservation?
    weak var progressDelegate: URLSessionProviderProgressDelegate?
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
        
    deinit {
        observation?.invalidate()
    }
    
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable {
        let request = URLRequest(service: service)
        task = session.dataTask(request: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        }
        observation = task?.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            guard let strongSelf = self else {return}
            strongSelf.progressDelegate?.progress(value: progress.fractionCompleted)
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (NetworkResponse<T>) -> ()) {
        
        guard error == nil else {
            print(error as Any)
            return completion(.failure(.networkError))
        }
        guard let response = response else { return completion(.failure(.noJSONData)) }
        
        
        switch response.statusCode {
            
        case 200...299:
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    print(error.localizedDescription, "ERROR:", error)
                    completion(.failure(.decodeError))
                }
            }
        case 404:
            completion(.failure(.serverOutOfLine))
        default:
            completion(.failure(.unknown))
        }
        
    }
    
}
