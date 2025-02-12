//
//  DetailRouter.swift
//  SearchUser2
//
//  Created by Leojin on 2/12/25.
//

protocol DetailRoutingLogic {
    func routeDismiss()
}

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

class DetailRouter: DetailRoutingLogic, DetailDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
    
    func routeDismiss() {
        viewController?.dismiss(animated: true)
    }
}
