//
//  SearchStore.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import Foundation


class SearchAPIStore: SearchAPIStoreProtocol {
    
    /// name으로 서버에 검색을 요청한다.
    ///
    ///  @param request: 검색할 요청 데이터(name, page, perPage)
    func searchUsers<T: Decodable>(request: SearchUserRequest, type: T.Type) async throws -> T? where T : Decodable {
        guard let requestURL = SearchAPI(reqParam: request).requestURL else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        let httpResponse = response as? HTTPURLResponse
        print("status code: \(httpResponse?.statusCode)")
        if httpResponse?.statusCode != 200 {
            throw APIError.badResponse
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print("decode error : \(error)")
            print("decode error : \(error.localizedDescription)")
        }
        return nil
    }
}
