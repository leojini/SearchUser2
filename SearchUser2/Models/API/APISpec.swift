//
//  APISpec.swift
//  SearchUser2
//
//  Created by Leojin on 2/13/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case badResponse
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APISpec {
    var path: String { get set }
    var method: HttpMethod { get set }
    func urlPath(path: String) -> String
    func params() -> [URLQueryItem]
    func urlRequest(url: URL) -> URLRequest
}

extension APISpec {
    func urlPath(path: String) -> String {
        "\(APIDefine.baseURL)/\(path)"
    }
    
    func urlComponents() throws -> URLComponents {
        guard var urlComp = URLComponents(string: urlPath(path: path)) else {
            throw URLError(.badURL)
        }
        urlComp.queryItems = params()
        return urlComp
    }
    
    func params(keyValues: [String: String?]) -> [URLQueryItem] {
        return keyValues.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
    
    func urlRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
//        print("url: \(request.url?.absoluteString)")
//        print("header fields : \(request.allHTTPHeaderFields)")
//        print("query: \(request.url?.query)")
        
        return request
    }
}
