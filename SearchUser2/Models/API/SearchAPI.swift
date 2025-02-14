//
//  SearchAPI.swift
//  NetworkKit
//
//  Created by Leojin on 1/15/25.
//

import Foundation


// 아래의 url 형태로 사용자 검색을 요청한다.
// https://api.github.com/search/users?q=a&page=1&per_page=30

struct SearchAPI: APISpec {
    var path = "search/users"
    var method = HttpMethod.get
    let reqParam: SearchUserRequest
    
    func params() -> [URLQueryItem] {
        return params(keyValues: ["q": reqParam.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                  "page": "\(reqParam.page)",
                                  "per_page": "\(reqParam.perPage)"])
    }
    
    var requestURL: URL? {
        guard let urlComponents = try? urlComponents() else { return nil }
        guard let url = urlComponents.url else { return nil }
        return urlRequest(url: url).url
    }
}
