//
//  APIViewRouters.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import UIKit

protocol APIRoutingLogic {
    func routeToDetail(row: Int)
}

protocol APIDataPassing {
    var dataStore: APIDataStore? { get }
}

class APIRouter: APIRoutingLogic, APIDataPassing {
    weak var viewController: APIViewController?
    var dataStore: APIDataStore?
    
    func routeToDetail(row: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let detailVC: DetailViewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            return
        }
        
        if let sourceDS = dataStore, var destinationDS = detailVC.router?.dataStore {
            passDataToDetail(destination: &destinationDS, row: row)
            if let viewController = viewController {
                presentToDetail(source: viewController, destination: detailVC)
            }
        }
    }
    
    func passDataToDetail(destination: inout DetailDataStore, row: Int) {
        destination.item = viewController?.datas[row]
        
    }
    
    func presentToDetail(source: APIViewController, destination: DetailViewController) {
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true)
    }
}
