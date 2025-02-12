//
//  LocalPresenter.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

protocol LocalPresenterLogic {
    func presentFetchName(response: Local.FetchName.Response)
    func presentRemoveFavorite(response: Local.RemoveFavorite.Response)
}

protocol LocalPresenterData {
    var datas: [Local.FetchName.ViewModel.LocalGroupViewData] { get set }
}

class LocalPresenter: LocalPresenterLogic, LocalPresenterData {
    weak var viewController: LocalDisplayLogic?
    var datas: [Local.FetchName.ViewModel.LocalGroupViewData] = []
    
    func presentFetchName(response: Local.FetchName.Response) {
        let localDatas = response.favoriteDatas
        let datas = localDatas.map {
            return Local.FetchName.ViewModel.LocalViewData(id: $0.id, name: $0.name, profileUrl: $0.profileUrl)
        }

        // 초성별 그룹 데이터를 만든 후 데이터에 설정한다.
        let maker = Local.FetchName.ViewModel.LocalGroupViewDatasMaker(items: datas)
        self.datas = maker.groupDatas
        
        viewController?.displayFetchName(viewModel: Local.FetchName.ViewModel(groupDatas: self.datas))
    }
    
    func presentRemoveFavorite(response: Local.RemoveFavorite.Response) {
        viewController?.displayRemoveFavorite(viewModel: Local.RemoveFavorite.ViewModel())
    }
}
