//
//  APIInteractor.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import RxSwift

protocol APIBusinessLogic {
    var isFetching: Bool { get set }
    func fetchUsers(request: API.FetchUsers.Request) throws
    func fetchUsersCache(request: API.FetchUsers.Request)
    func addFavorite(request: API.AddFavorite.Request)
    func removeFavorite(request: API.RemoveFavorite.Request)
}

protocol APIDataStore {
    var searchResponse: SearchUserResponse? { get }
}

class APIInteractor: APIBusinessLogic, APIDataStore {
    private let disposeBag = DisposeBag()
    var presenter: APIPresenterLogic?
    var searchWorker = SearchAPIWorker(searchStore: SearchAPIStore())
    var isFetching: Bool = false
    var searchResponse: SearchUserResponse?
    
    /// API 호출 이 후 데이터를 presenter에 응답을 넘겨준다.
    ///
    @MainActor func fetchUsers(request: API.FetchUsers.Request) throws {
        if isFetching {
            return
        }
        
        isFetching = true
        
        Task {
            do {
                guard let data = try? await searchWorker.fetchUsers(request: request.searchRequest, type: SearchUserResponse.self) else {
                    throw APIError.badResponse
                }
                
                var data2 = data
                let items = data.items.filter {
                    // 이름이 검색어를 포함하는 데이터만 추출한다.
                    return $0.login.lowercased().contains(request.searchRequest.name)
                }
                
                data2.items = items
                self.searchResponse = data2
                let response = API.FetchUsers.Response(success: true, searchName: request.searchRequest.name, searchResponse: data2, page: request.searchRequest.page)
                self.presenter?.presentFetchUsers(response: response)
                isFetching = false
            } catch {
                isFetching = false
                print("error xx: \(error.localizedDescription)")
            }
        }
    }
    
    /// API 호출 없이 이전 데이터를 presenter에 응답을 넘겨준다.
    ///
    func fetchUsersCache(request: API.FetchUsers.Request) {
        if let searchResponse = searchResponse {
            let response = API.FetchUsers.Response(success: true, searchName: request.searchRequest.name, searchResponse: searchResponse, page: request.searchRequest.page)
            self.presenter?.presentFetchUsersCache(response: response)
        }
    }
    
    /// 로컬 데이터 추가한 후 presenter에 응답을 넘겨준다.
    ///
    func addFavorite(request: API.AddFavorite.Request) {
        let localWorker = LocalWorker(localStore: LocalStore())
        localWorker.addLocalData(request.id, name: request.name, avatarUrl: request.profileUrl)
        self.presenter?.presentAddFavorite(response: API.AddFavorite.Response())
    }
    
    /// 로컬 데이터 삭제한 후 presenter에 응답을 넘겨준다.
    ///
    func removeFavorite(request: API.RemoveFavorite.Request) {
        let localWorker = LocalWorker(localStore: LocalStore())
        localWorker.removeLocalData(request.id, name: request.name)
        self.presenter?.presentRemoveFavorite(response: API.RemoveFavorite.Response())
    }
}
