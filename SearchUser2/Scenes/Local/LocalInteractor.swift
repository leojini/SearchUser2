//
//  LocalInteractor.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

protocol LocalBusinessLogic {
    func fetchDatas(request: Local.FetchName.Request)
    func removeFavorite(request: Local.RemoveFavorite.Request)
}

protocol LocalDataStore {
    var favoriteDatas: [FavoriteData]? { get }
}

class LocalInteractor: LocalBusinessLogic, LocalDataStore {
    var presenter: LocalPresenterLogic?
    var localWorker = LocalWorker(localStore: LocalStore())
    var favoriteDatas: [FavoriteData]?
    
    func fetchDatas(request: Local.FetchName.Request) {
        let datas = localWorker.selectDatas(request.name)
        favoriteDatas = datas
        presenter?.presentFetchName(response: Local.FetchName.Response(favoriteDatas: datas))
    }
    
    func removeFavorite(request: Local.RemoveFavorite.Request) {
        localWorker.removeLocalData(request.id, name: request.name)
        presenter?.presentRemoveFavorite(response: Local.RemoveFavorite.Response())
    }
}
