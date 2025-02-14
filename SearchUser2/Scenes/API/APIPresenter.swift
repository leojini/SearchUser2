//
//  APIPresenter.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

protocol APIPresenterLogic {
    func presentFetchUsers(response: API.FetchUsers.Response)
    func presentFetchUsersCache(response: API.FetchUsers.Response)
    func presentAddFavorite(response: API.AddFavorite.Response)
    func presentRemoveFavorite(response: API.RemoveFavorite.Response)
}

protocol APIPresenterData {
    var datas: [API.FetchUsers.ViewModel.APIViewData] { get set }
}

class APIPresenter: APIPresenterLogic, APIPresenterData {
    weak var viewController: APIDisplayLogic?
    var datas: [API.FetchUsers.ViewModel.APIViewData] = []
    
    func presentFetchUsers(response: API.FetchUsers.Response) {
        if response.success {
            let data = response.searchResponse
            let items = data.items
            let viewDatas = items.map {
                // 뷰 데이터를 구성한다.
                let id = "\($0.id)"
                let name = $0.login
                let localWorker = LocalWorker(localStore: LocalStore())
                let isFavorite = localWorker.isFavorite(id, name: name)
                
                return API.FetchUsers.ViewModel.APIViewData(id: id,
                                                            name: name,
                                                            profileUrl: $0.avatar_url,
                                                            favorite: isFavorite)
            }
            
            if response.page > 1 {
                // 다음 페이지 데이터를 요청한 경우
                // 기존 데이터에 추가한다.
                var oriViewDatas = self.datas
                oriViewDatas.append(contentsOf: viewDatas)
                self.datas = oriViewDatas
                viewController?.displayFetchUsers(viewModel: API.FetchUsers.ViewModel(totalCount: data.total_count, datas: oriViewDatas, errorMessage: ""))
            } else {
                // 첫 번째 페이지를 요청한 경우
                self.datas = viewDatas
                viewController?.displayFetchUsers(viewModel: API.FetchUsers.ViewModel(totalCount: data.total_count, datas: viewDatas, errorMessage: ""))
            }
        } else {
            viewController?.displayFetchUsers(viewModel: API.FetchUsers.ViewModel(totalCount: 0, datas: [], errorMessage: response.errorMessage))
        }
    }
    
    func presentFetchUsersCache(response: API.FetchUsers.Response) {
        let data = response.searchResponse
        
        let viewDatas = self.datas.map {
            // 뷰 데이터를 구성한다.
            let itemData = $0
            let localWorker = LocalWorker(localStore: LocalStore())
            let isFavorite = localWorker.isFavorite(itemData.id, name: itemData.name)
            
            return API.FetchUsers.ViewModel.APIViewData(id: itemData.id,
                                                        name: itemData.name,
                                                        profileUrl: itemData.profileUrl,
                                                        favorite: isFavorite)
        }
        self.datas = viewDatas
        
        viewController?.displayFetchUsers(viewModel: API.FetchUsers.ViewModel(totalCount: data.total_count, datas: viewDatas, errorMessage: ""))
    }
    
    func presentAddFavorite(response: API.AddFavorite.Response) {
        viewController?.displayAddFavorite(viewModel: API.AddFavorite.ViewModel())
    }
    
    func presentRemoveFavorite(response: API.RemoveFavorite.Response) {
        viewController?.displayRemoveFavorite(viewModel: API.RemoveFavorite.ViewModel())
    }
}
