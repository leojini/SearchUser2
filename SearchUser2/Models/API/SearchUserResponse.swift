//
//  NetworkModels.swift
//  NetworkKit
//
//  Created by Leojin on 1/15/25.
//

/// 사용자 검색 응답 모델
///
struct SearchUserResponse: Decodable {
    let total_count: Int // 전체 개수. (e.g. 1495406)
    let incomplete_results: Bool // 결과 완료 유무, (e.g. false)
    var items: [SearchUserItemResponse]
}

/// 사용자 검색 응답 아이템 모델
///
struct SearchUserItemResponse: Decodable {
    let login: String // "A",
    let id: Int // 1410106,
    let avatar_url: String // "https://avatars.githubusercontent.com/u/1410106?v=4",
}
