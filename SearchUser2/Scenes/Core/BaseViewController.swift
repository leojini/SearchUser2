//
//  BaseViewController.swift
//  SearchUserApp
//
//  Created by Leojin on 1/17/25.
//

import UIKit

/**
 뷰 컨트롤러 공통 구현
 */
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGes)
    }
 
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 키보드 내리기
        self.view.endEditing(true)
    }
}
