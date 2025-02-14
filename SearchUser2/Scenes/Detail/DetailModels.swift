//
//  DetailModels.swift
//  SearchUser2
//
//  Created by Leojin on 2/12/25.
//

enum Detail {
    // MARK: Use cases
    enum Info {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let id: String // 아이디
            let name: String // 이름
            let profileUrl: String // 프로필 이미지 url
            var favorite: Bool
        }
    }
}
