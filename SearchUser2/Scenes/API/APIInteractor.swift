//
//  APIInteractor.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import RxSwift

protocol APIBusinessLogic {
    var isFetching: Bool { get set }
    func fetchUsers(request: API.FetchUsers.Request)
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
    func fetchUsers(request: API.FetchUsers.Request) {
        if isFetching {
            return
        }
        
        isFetching = true
        
        searchWorker.fetchUsers(request: request.searchRequest, type: SearchUserResponse.self)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    var data2 = data
                    let items = data.items.filter {
                        // 이름이 검색어를 포함하는 데이터만 추출한다.
                        return $0.getData().name.lowercased().contains(request.searchRequest.name)
                    }
                    
                    data2.items = items
                    self.searchResponse = data2
                    let response = API.FetchUsers.Response(success: true, searchName: request.searchRequest.name, searchResponse: data2, page: request.searchRequest.page)
                    self.presenter?.presentFetchUsers(response: response)
                    isFetching = false
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    let response = API.FetchUsers.Response(success: false, searchName: request.searchRequest.name, searchResponse: .init(total_count: 0, incomplete_results: false, items: []), page: request.searchRequest.page, errorMessage: error.localizedDescription)
                    self.presenter?.presentFetchUsers(response: response)
                    isFetching = false
                }
            }
            .disposed(by: disposeBag)
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
