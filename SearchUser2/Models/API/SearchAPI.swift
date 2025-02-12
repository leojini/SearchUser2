//
//  SearchAPI.swift
//  NetworkKit
//
//  Created by Leojin on 1/15/25.
//

import Foundation
import Moya

// 아래의 url 형태로 사용자 검색을 요청한다.
// https://api.github.com/search/users?q=a&page=1&per_page=30

enum SearchAPI {
    // 사용자 검색: pageNo, perPage를 파라미터로 전달받아서 요청
    case searchUsers(request: SearchUserRequest)
}

extension SearchAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .searchUsers(_):
            return "search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchUsers(_):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchUsers(let request):
            let params: [String: String] = [
                "q": request.name,
                "page": "\(request.page)",
                "per_page": "\(request.perPage)",
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchUsers(_):
            return ["Content-type": "application/json"]
        }
    }
}
