//
//  LocalViewController.swift
//  SearchUserApp
//
//  Created by Leojin on 1/16/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol LocalDisplayLogic: AnyObject {
    func displayFetchName(viewModel: Local.FetchName.ViewModel)
    func displayRemoveFavorite(viewModel: Local.RemoveFavorite.ViewModel)
}

/**
 로컬에 저장된 즐겨찾기 데이터를 보여준다.
 */
class LocalViewController: BaseViewController, LocalDisplayLogic {
    
    var interactor: LocalBusinessLogic?
    var router: LocalRoutingLogic?
    var datas: [Local.FetchName.ViewModel.LocalGroupViewData] = []
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!  // 검색어 입력
    @IBOutlet weak var tableView: UITableView!  // 검색된 아이템 표시
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        initUI()
        bind()
    }
    
    private func setup() {
        let viewController = self
        let interactor = LocalInteractor()
        let presenter = LocalPresenter()
        let router = LocalRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /// 최초 로드시 UI를 초기화한다.
    ///
    private func initUI() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchTextField.autocorrectionType = .no
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.spellCheckingType = .no
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    /// 뷰 모델 데이터와 바인딩한다.
    ///
    private func bind() {
        // 검색어가 변경된 이 후 0.5초 동안 변경되지 않으면 해당 검색어로 로컬 데이터를 검색한다.
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.searchDatas(false, name: text)
            })
            .disposed(by: disposeBag)
    }
    
    /// 데이터를 업데이트 한 후 tableView를 갱신한다.
    ///
    func displayFetchName(viewModel: Local.FetchName.ViewModel) {
        self.datas = viewModel.groupDatas
        tableView.reloadData()
    }
    
    /// 즐겨찾기에서 삭제한 이 후 데이터를 재요청한다.
    ///
    func displayRemoveFavorite(viewModel: Local.RemoveFavorite.ViewModel) {
        interactor?.fetchDatas(request: Local.FetchName.Request(name: searchBar.text ?? ""))
    }
    
    /// 검색어 입력 후 검색 버튼을 누를 때 해당 이름으로 검색한다.
    ///
    /// @param isInit 최초 검색시 true
    /// @param name 이름
    func searchDatas(_ isInit: Bool, name: String = "") {
        if isInit {
            interactor?.fetchDatas(request: Local.FetchName.Request(name: searchBar.text ?? ""))
        } else {
            interactor?.fetchDatas(request: Local.FetchName.Request(name: name))
        }
    }
}

extension LocalViewController: UITableViewDelegate, UITableViewDataSource, UserCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let item = datas[indexPath.section].items[indexPath.row]
        cell.delegate = self
        cell.update(section: indexPath.section,
                    index: indexPath.row,
                    name: item.name,
                    profileUrlString: item.profileUrl,
                    isFavorite: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datas[section].first
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return datas.compactMap({ $0.first })
    }
    
    /// 즐겨찾기를 해제한다.
    ///
    func didTapFavoriteButton(section: Int, index: Int) {
        let item = datas[section].items[index]
        interactor?.removeFavorite(request: Local.RemoveFavorite.Request(id: item.id, name: item.name))
    }
    
    func didTapItem(section: Int, index: Int) {
        router?.routeToDetail(section: section, index: index)
    }
}

extension LocalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
