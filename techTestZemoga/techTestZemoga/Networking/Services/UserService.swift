//
//  UserService.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

enum UserService: ServiceProtocol {
    
    case getUserDetails(_ userId: Int)
    
    var path: String {
        
        let basePath = "users/"
        
        switch self {
        case .getUserDetails(let userId):
            return basePath + "\(userId)"
        }
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .getUserDetails:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
        case .getUserDetails:
            return .request
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        
        switch self {
        case .getUserDetails:
            return .url
        }
    }
}
