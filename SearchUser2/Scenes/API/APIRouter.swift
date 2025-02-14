//
//  APIViewRouters.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import UIKit

protocol APIRoutingLogic {
    func routeToDetail(index: Int)
}

protocol APIDataPassing {
    var dataStore: APIPresenterData? { get }
}

class APIRouter: APIRoutingLogic, APIDataPassing {
    weak var viewController: APIViewController?
    var dataStore: APIPresenterData?
    
    func routeToDetail(index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC: DetailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        if var destinationDS = detailVC.router?.dataStore {
            passDataToDetail(destination: &destinationDS, index: index)
            if let viewController = viewController {
                presentToDetail(source: viewController, destination: detailVC)
            }
        }
    }
    
    func passDataToDetail(destination: inout DetailDataStore, index: Int) {
        if let item = dataStore?.datas[index] {
            destination.item = .init(id: item.id, name: item.name, profileUrl: item.profileUrl, favorite: item.favorite)
        }
    }
    
    func presentToDetail(source: APIViewController, destination: DetailViewController) {
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true)
    }
}
