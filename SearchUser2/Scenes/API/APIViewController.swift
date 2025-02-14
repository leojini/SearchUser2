//
//  APIViewController.swift
//  SearchUserApp
//
//  Created by Leojin on 1/16/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol APIDisplayLogic: AnyObject {
    func displayFetchUsers(viewModel: API.FetchUsers.ViewModel)
    func displayAddFavorite(viewModel: API.AddFavorite.ViewModel)
    func displayRemoveFavorite(viewModel: API.RemoveFavorite.ViewModel)
}

/**
 API 검색 데이터를 리스트 형태로 보여준다.
 */
class APIViewController: BaseViewController, APIDisplayLogic {
    
    var interactor: APIBusinessLogic?
    var router: APIRoutingLogic?
    private var datas: [API.FetchUsers.ViewModel.APIViewData] = []
    private let disposeBag = DisposeBag()
    private var page: Int = 1
    
    @IBOutlet weak var searchBar: UISearchBar!  // 검색어 입력
    @IBOutlet weak var errorView: UIView!   // 에러뷰
    @IBOutlet weak var errorLabel: UILabel! // 에러 표시
    @IBOutlet weak var tableView: UITableView!  // 검색된 아이템 표시
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        initUI()
        bind()
    }
    
    private func setup() {
        let viewController = self
        let interactor = APIInteractor()
        let presenter = APIPresenter()
        let router = APIRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = presenter
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
        // 검색어가 변경된 이 후 0.5초 동안 변경되지 않으면 해당 검색어로 API 검색을 요청한다.
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.searchDatas(text)
            })
            .disposed(by: disposeBag)
    }
    
    func displayFetchUsers(viewModel: API.FetchUsers.ViewModel) {
        guard let text = searchBar.text, text.isEmpty == false else {
            removeDatas()
            return
        }
        
        if !viewModel.errorMessage.isEmpty {
            errorLabel.text = "API 호출 에러입니다. 잠시 후에 다시 시도해주세요.\n\(viewModel.errorMessage)"
            errorView.isHidden = false
        } else {
            // 뷰 데이터를 설정한다.
            self.datas = viewModel.datas
            errorView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    /// 데이터를 현재 검색어로 재요청 한다.
    ///
    func updateDatas() {
        interactor?.fetchUsersCache(request: API.FetchUsers.Request(searchRequest: .init(name: searchBar.text ?? "", page: page)))
    }
    
    /// 검색어 입력 후 검색 버튼을 누를 때 해당 이름으로 검색한다.
    /// 이름이 공백일 경우 뷰 데이터 전체를 삭제한 후 tableView를 갱신한다.
    ///
    /// @param name 이름
    private func searchDatas(_ name: String) {
        let name2 = name.replacingOccurrences(of: " ", with: "")
        if name2.isEmpty {
            removeDatas()
        } else {
            page = 1
            try? interactor?.fetchUsers(request: API.FetchUsers.Request(searchRequest: .init(name: name, page: page)))
        }
    }
    
    /// 뷰 데이터들을 모두 삭제한 후 tableView를 갱신한다.
    ///
    private func removeDatas() {
        page = 1
        datas.removeAll()
        tableView.reloadData()
        errorView.isHidden = true
    }
}

extension APIViewController: UITableViewDelegate, UITableViewDataSource, UserCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let item = datas[indexPath.row]
        cell.delegate = self
        cell.update(section: indexPath.section,
                    index: indexPath.row,
                    name: item.name,
                    profileUrlString: item.profileUrl,
                    isFavorite: item.favorite)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gapHeight = scrollView.contentSize.height - scrollView.contentOffset.y
        
        // 스크롤 마지막일 경우
        if datas.count > 0 && gapHeight > 0 && gapHeight < scrollView.frame.height {
            if let interactor = interactor, !interactor.isFetching {
                // 다음 페이지 데이터를 요청한다.
                page += 1
                try? interactor.fetchUsers(request: API.FetchUsers.Request(searchRequest: .init(name: searchBar.text ?? "", page: page)))
            }
        }
    }
    
    /// 즐겨찾기 선택 혹은 해제한다.
    ///
    func didTapFavoriteButton(section: Int, index: Int) {
        let item = datas[index]
        if item.favorite {
            interactor?.removeFavorite(request: API.RemoveFavorite.Request(id: item.id, name: item.name))
        } else {
            interactor?.addFavorite(request: API.AddFavorite.Request(id: item.id, name: item.name, profileUrl: item.profileUrl))
        }
    }
    
    func didTapItem(section: Int, index: Int) {
        router?.routeToDetail(index: index)
    }
    
    func displayAddFavorite(viewModel: API.AddFavorite.ViewModel) {
        updateDatas()
    }
    
    func displayRemoveFavorite(viewModel: API.RemoveFavorite.ViewModel) {
        updateDatas()
    }
}

extension APIViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
