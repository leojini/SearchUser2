//
//  APIViewModel.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

enum API {
    // MARK: Use cases
    enum FetchUsers {
        struct Request {
            var searchRequest: SearchUserRequest
        }
        struct Response {
            var success: Bool
            var searchName = ""
            var searchResponse: SearchUserResponse
            var page: Int
            var errorMessage = ""
        }
        struct ViewModel {
            struct APIViewData {
                let id: String // 아이디
                let name: String // 이름
                let profileUrl: String // 프로필 이미지 url
                var favorite = false // 즐겨찾기 저장 유무
            }
            
            var totalCount: Int
            var datas: [APIViewData]
            var errorMessage: String
        }
    }
    
    enum AddFavorite {
        struct Request {
            var id: String
            var name: String
            var profileUrl: String
        }
        struct Response {
            
        }
        struct ViewModel {
            
        }
    }
    
    enum RemoveFavorite {
        struct Request {
            var id: String
            var name: String
        }
        struct Response {
            
        }
        struct ViewModel {
            
        }
    }
}
