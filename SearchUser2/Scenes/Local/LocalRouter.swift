//
//  LocalRouter.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

protocol LocalRoutingLogic {
    
}

class LocalRouter: LocalRoutingLogic {
    weak var viewController: LocalViewController?
    var dataStore: LocalDataStore?
}
