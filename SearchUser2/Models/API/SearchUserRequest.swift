//
//  SearchUserRequest.swift
//  NetworkKit
//
//  Created by Leojin on 1/15/25.
//


/// 사용자 검색 요청 모델
///
/// 디폴트 요청인 경우 page는 1이고 perPage는 30이다.
struct SearchUserRequest {
    let name: String
    var page: Int = 1
    var perPage: Int = 30
    
    init(name: String, page: Int) {
        self.name = name
        self.page = page
    }
    
    init(name: String, page: Int, perPage: Int) {
        self.name = name
        self.page = page
        self.perPage = perPage
    }
}
