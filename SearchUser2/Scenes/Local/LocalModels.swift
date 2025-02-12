//
//  LocalModels.swift
//  SearchUser2
//
//  Created by Leojin on 1/22/25.
//

enum Local {
    // MARK: Use cases
    enum FetchName {
        struct Request {
            var name: String
        }
        struct Response {
            var favoriteDatas: [FavoriteData]
        }
        struct ViewModel {
            struct LocalViewData {
                let id: String // 아이디
                let name: String // 이름
                let profileUrl: String // 프로필 이미지 url
            }

            struct LocalGroupViewData {
                let first: String // 이름의 초성
                let items: [LocalViewData] // 초성에 속한 뷰 데이터들
            }

            struct LocalGroupViewDatasMaker {
                let items: [LocalViewData] // 로컬 즐겨찾기에 저장된 데이터
                
                init(items: [LocalViewData]) {
                    self.items = items
                }
                
                // 초성에 속한 뷰 데이터들을 반환한다.
                var groupDatas: [LocalGroupViewData] {
                    // 알파벳 오름차순으로 정렬한다.
                    let sortedArr = items.sorted(by: {
                        $0.name.lowercased() < $1.name.lowercased()
                    })
                    
                    // 초성 배열을 중복을 제거한 후 배열로 변환 후 오름차순 정렬한다.
                    let firstArr = Array(Set(sortedArr.map {
                        $0.name.first?.lowercased() ?? ""
                    })).sorted(by: {
                        $0 < $1
                    })
                    
                    // 초성에 해당하는 아이템들을 얻는다.
                    let datas = firstArr.map { first in
                        let items = sortedArr.filter {
                            $0.name.first?.lowercased() == first
                        }
                        return LocalGroupViewData(first: first, items: items)
                    }
                    
                    return datas
                }
            }
            
            var groupDatas: [LocalGroupViewData]
        }
    }
    
    // MARK: Use cases
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
