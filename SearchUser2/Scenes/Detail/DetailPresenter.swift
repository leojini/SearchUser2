//
//  DetailPresenter.swift
//  SearchUser2
//
//  Created by Leojin on 2/12/25.
//

protocol DetailPresenterLogic {
    func presentAddFavorite(response: API.AddFavorite.Response)
    func presentRemoveFavorite(response: API.RemoveFavorite.Response)
}

protocol DetailPresenterData {
    var data: Detail.Info.ViewModel { get set }
}

class DetailPresenter: DetailPresenterLogic, DetailPresenterData {
    weak var viewController: DetailDisplayLogic?
    var data: Detail.Info.ViewModel = .init(id: "", name: "", profileUrl: "", favorite: false)
    
    func presentAddFavorite(response: API.AddFavorite.Response) {
        viewController?.displayAddFavorite(viewModel: API.AddFavorite.ViewModel())
    }
    
    func presentRemoveFavorite(response: API.RemoveFavorite.Response) {
        viewController?.displayRemoveFavorite(viewModel: API.RemoveFavorite.ViewModel())
    }
}
