//
//  SearchUserData.swift
//  LocalDataKit
//
//  Created by Leojin on 1/15/25.
//

import Foundation
import RealmSwift

/// 즐겨찾기 데이터
///
class FavoriteData: Object {
    @Persisted var id = "" // 아이디, e.g. 1410106
    @Persisted var name = "" // 이름, e.g. "A",
    @Persisted var profileUrl = "" // 프로파일 url, e.g. "https://avatars.githubusercontent.com/u/1410106?v=4",
    
    convenience init(id: String, name: String, profileUrl: String) {
        self.init()
        self.id = id
        self.name = name
        self.profileUrl = profileUrl
    }
}
