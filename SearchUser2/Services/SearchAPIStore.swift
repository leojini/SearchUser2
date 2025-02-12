//
//  SearchStore.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import Foundation
import RxSwift
import Moya

class SearchAPIStore: SearchAPIStoreProtocol {
    
    /// name으로 서버에 검색을 요청한다.
    ///
    ///  @param request: 검색할 요청 데이터(name, page, perPage)
    func searchUsers<T>(request: SearchUserRequest, type: T.Type) -> Single<T> where T : Decodable {
        return Single.create { single in
            let provider = MoyaProvider<SearchAPI>()
            provider.request(.searchUsers(request: request)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodeData = try JSONDecoder().decode(T.self, from: response.data)
                        single(.success(decodeData))
                    } catch {
                        single(.failure(error))
                    }
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
