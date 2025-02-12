//
//  MainViewController.swift
//  SearchUserApp
//
//  Created by Leojin on 1/15/25.
//

import UIKit
import RxSwift
import SnapKit

/**
 앱 최초 진입 컨트롤러
 */
class MainViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private var apiVC: APIViewController?      // API 검색 아이템들을 보여줄 뷰 컨트롤러
    private var localVC: LocalViewController?  // 로컬 아이템들을 보여줄 뷰 컨트롤러
    private var isAPI = true
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var apiSelectView: UIView!
    @IBOutlet weak var localSelectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 초기화
        if initUI() {
            // 레이아웃을 설정한다.
            setupLayout()
            
            // 최초 API 메뉴 선택
            selectMenu(isAPI: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAPI {
            apiVC?.updateDatas()
        } else {
            localVC?.searchDatas(true)
        }
    }
    
    /// 최초 로드시 UI를 초기화한다.
    /// 메뉴별 apiVC, localVC를 생성 후 추가한다.
    ///
    private func initUI() -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let apiVC: APIViewController = storyboard.instantiateViewController(identifier: "APIViewController") as? APIViewController else {
            return false
        }
        guard let localVC: LocalViewController = storyboard.instantiateViewController(identifier: "LocalViewController") as? LocalViewController else {
            return false
        }
        
        addVC(apiVC)
        addVC(localVC)
        
        self.apiVC = apiVC
        self.localVC = localVC
        
        return true
    }
    
    /// 뷰 컨트롤러를 추가한다.
    ///
    /// @param vc 추가할 뷰 컨트롤러
    private func addVC(_ vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    /// 추가된 뷰 컨트롤러 apiVC, localVC의 레이아웃을 설정한다.
    ///
    private func setupLayout() {
        guard let apiVC = apiVC, let localVC = localVC else { return }
        
        apiVC.view.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        localVC.view.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// API 또는 로컬 메뉴를 선택한다.
    ///
    /// @param isAPI true이면 API를 선택, false이면 로컬을 선택한다.
    private func selectMenu(isAPI: Bool) {
        apiSelectView.isHidden = true
        localSelectView.isHidden = true
        apiVC?.view.isHidden = true
        localVC?.view.isHidden = true
        if isAPI {
            apiSelectView.isHidden = false
            apiVC?.view.isHidden = false
            apiVC?.updateDatas()
        } else {
            localSelectView.isHidden = false
            localVC?.view.isHidden = false
            localVC?.searchDatas(true)
        }
        
        self.isAPI = isAPI
        self.view.endEditing(true)
    }
    
    /// API 버튼을 선택한다.
    ///
    @IBAction func onAPIButton(_ sender: Any) {
        selectMenu(isAPI: true)
    }
    
    /// 로컬 버튼을 선택한다.
    ///
    @IBAction func onLocalButton(_ sender: Any) {
        selectMenu(isAPI: false)
    }
}

