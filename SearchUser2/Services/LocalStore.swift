//
//  LocalStore.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

import Foundation
import RealmSwift

class LocalStore: LocalStoreProtocol {
    
    init() {
        // Realm 모델 변경시 스키마 버전을 1씩 올려줘야 한다.
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// 즐겨찾기 데이터를 추가한다.
    ///
    /// @param id 아이디
    /// @param name 이름
    /// @param avatarUrl 프로필 이미지 url
    func addLocalData(_ id: String, name: String, avatarUrl: String) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(FavoriteData(id: id, name: name, profileUrl: avatarUrl))
        }
    }
    
    /// 즐겨찾기 데이터를 삭제한다.
    ///
    /// @param id 아이디
    /// @param name 이름
    func removeLocalData(_ id: String, name: String) {
        let realm = try! Realm()
        let datas = realm.objects(FavoriteData.self).where {
            ($0.id == id && $0.name == name)
        }
        
        if let data = datas.first {
            try! realm.write {
                realm.delete(data)
            }
        }
    }
    
    /// name과 같은 데이터들을 반환한다.
    ///
    /// @param name 검색할 이름
    func selectDatas(_ name: String) -> [FavoriteData] {
        let realm = try! Realm()
        
        if name.isEmpty { // 검색어가 없는 경우 전체 데이터를 반환한다.
            let datas = realm.objects(FavoriteData.self)
            return Array(datas)
        }
        
        let datas = realm.objects(FavoriteData.self).where {
            // name과 같은 데이터를 대소문자 구분없이 비교한다.
            $0.name.contains(name, options: .caseInsensitive)
        }
        return Array(datas)
    }
    
    /// id, name과 같은 데이터가 즐겨찾기 데이터에 있을 경우 true를 반환한다.
    ///
    /// @param id 아이디
    /// @param name 이름
    func isFavorite(_ id: String, name: String) -> Bool {
        let realm = try! Realm()
        let datas = realm.objects(FavoriteData.self).where {
            $0.id == id && $0.name == name
        }
        return Array(datas).count > 0
    }
}
