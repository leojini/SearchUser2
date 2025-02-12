//
//  SearchWorker.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import Moya
import RxSwift

protocol SearchAPIStoreProtocol
{
    func searchUsers<T: Decodable>(request: SearchUserRequest, type: T.Type) -> Single<T>
}

class SearchAPIWorker {
    var searchStore: SearchAPIStoreProtocol
    
    init(searchStore: SearchAPIStoreProtocol) {
        self.searchStore = searchStore
    }
    
    func fetchUsers<T: Decodable>(request: SearchUserRequest, type: T.Type) -> Single<T> {
        return searchStore.searchUsers(request: request, type: T.self)
    }
}
