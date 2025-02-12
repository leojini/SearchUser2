//
//  LocalWorker.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

protocol LocalStoreProtocol
{
    func addLocalData(_ id: String, name: String, avatarUrl: String)
    func removeLocalData(_ id: String, name: String)
    func selectDatas(_ name: String) -> [FavoriteData]
    func isFavorite(_ id: String, name: String) -> Bool
}

class LocalWorker {
    var localStore: LocalStoreProtocol
    
    init(localStore: LocalStoreProtocol) {
        self.localStore = localStore
    }
    
    func addLocalData(_ id: String, name: String, avatarUrl: String) {
        localStore.addLocalData(id, name: name, avatarUrl: avatarUrl)
    }
    
    func removeLocalData(_ id: String, name: String) {
        localStore.removeLocalData(id, name: name)
    }
    
    func selectDatas(_ name: String) -> [FavoriteData] {
        return localStore.selectDatas(name)
    }
    
    func isFavorite(_ id: String, name: String) -> Bool {
        return localStore.isFavorite(id, name: name)
    }
}
