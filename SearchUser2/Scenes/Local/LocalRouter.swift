//
//  LocalRouter.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import UIKit

protocol LocalRoutingLogic {
    func routeToDetail(section: Int, index: Int)
}

protocol LocalDataPassing {
    var dataStore: LocalPresenterData { get }
}

class LocalRouter: LocalRoutingLogic {
    weak var viewController: LocalViewController?
    var dataStore: LocalPresenterData?
    
    func routeToDetail(section: Int, index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC: DetailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        if var destinationDS = detailVC.router?.dataStore {
            passDataToDetail(destination: &destinationDS, section: section, index: index)
            if let viewController = viewController {
                presentToDetail(source: viewController, destination: detailVC)
            }
        }
    }
    
    func passDataToDetail(destination: inout DetailDataStore, section: Int, index: Int) {
        if let item = dataStore?.datas[section].items[index] {
            destination.item = .init(id: item.id, name: item.name, profileUrl: item.profileUrl, favorite: true)
        }
    }
    
    func presentToDetail(source: LocalViewController, destination: DetailViewController) {
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true)
    }
}
