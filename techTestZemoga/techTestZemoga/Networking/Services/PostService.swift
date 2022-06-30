//
//  PostService.swift
//  techTestZemoga
//
//  Created by Richard Pacheco on 6/30/22.
//

enum PostService: ServiceProtocol {
    
    case getPostsFromApi
    case getComments(_ postId: Int)
    
    var path: String {
        
        let basePath = "posts"
        
        switch self {
        case .getPostsFromApi:
            return basePath
        case .getComments(let postId):
            return basePath + "/\(postId)/comments"
        }
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .getPostsFromApi, .getComments:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
        case .getPostsFromApi, .getComments:
            return .request
        }
    }
    
    var parametersEncoding: ParametersEncoding {
        
        switch self {
        case .getPostsFromApi, .getComments:
            return .url
        }
    }
}
