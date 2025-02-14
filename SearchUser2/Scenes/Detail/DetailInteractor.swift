//
//  DetailInteractor.swift
//  SearchUser2
//
//  Created by Leojin on 2/12/25.
//

protocol DetailBusinessLogic {
    func addFavorite(request: API.AddFavorite.Request)
    func removeFavorite(request: API.RemoveFavorite.Request)
}

protocol DetailDataStore {
    var item: Detail.Info.ViewModel? { get set }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {
    var presenter: DetailPresenterLogic?
    var item: Detail.Info.ViewModel?
    
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
