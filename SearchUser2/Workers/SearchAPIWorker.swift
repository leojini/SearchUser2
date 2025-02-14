//
//  SearchWorker.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import RxSwift

protocol SearchAPIStoreProtocol {
    func searchUsers<T: Decodable>(request: SearchUserRequest, type: T.Type) async throws -> T?
}

class SearchAPIWorker {
    var searchStore: SearchAPIStoreProtocol
    
    init(searchStore: SearchAPIStoreProtocol) {
        self.searchStore = searchStore
    }
    
    func fetchUsers<T: Decodable>(request: SearchUserRequest, type: T.Type) async throws -> T? {
        return try await searchStore.searchUsers(request: request, type: T.self)
    }
}
