//
//  SearchUser2Tests.swift
//  SearchUser2Tests
//
//  Created by Leojin on 1/22/25.
//

import XCTest
@testable import SearchUser2

final class SearchUser2Tests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_LocalWorker() {
        let arr = [
            (id: "1", name: "aaa"),
            (id: "2", name: "bbb"),
            (id: "3", name: "ccc"),
            (id: "4", name: "ddd"),
            (id: "5", name: "eee")
        ]
        
        let worker = LocalWorker(localStore: LocalStore())
        arr.map {
            worker.addLocalData($0.id, name: $0.name, avatarUrl: "")
            let datas = worker.selectDatas($0.name)
            XCTAssertEqual(datas.count, 1, "\($0.id) 데이터를 찾을 수 없습니다.")
            
            worker.removeLocalData($0.id, name: $0.name)
            let datas2 = worker.selectDatas($0.name)
            XCTAssertEqual(datas2.count, 0, "\($0.name) 데이터가 삭제되지 않았습니다.")
        }
    }
    
    func test_SearchWorker() {
        let worker = SearchAPIWorker(searchStore: SearchAPIStore())
        let request = API.FetchUsers.Request(searchRequest: .init(name: "a", page: 1))
        Task {
            print("test!!!")
            if let data = try? await worker.fetchUsers(request: request.searchRequest, type: SearchUserResponse.self) {
                print("data's item count: \(data.items.count)")
                XCTAssertGreaterThan(data.items.count ?? 0, 0)
            }
            print("end")
        }
        
        
//        worker.fetchUsers(request: request.searchRequest, type: SearchUserResponse.self)
//            .subscribe { [weak self] result in
//                guard let self = self else { return }
//                
//                switch result {
//                case .success(let data):
//                    var data2 = data
//                    let items = data.items.filter {
//                        // 이름이 검색어를 포함하는 데이터만 추출한다.
//                        return $0.login.lowercased().contains(request.searchRequest.name)
//                    }
//                    
//                    data2.items = items
//                    //self.searchResponse = data2
//                    print("items: \(items)")
//                    let response = API.FetchUsers.Response(success: true, searchName: request.searchRequest.name, searchResponse: data2, page: request.searchRequest.page)
//                    
//                    
//                case .failure(let error):
//                    print("error: \(error.localizedDescription)")
//                    let response = API.FetchUsers.Response(success: false, searchName: request.searchRequest.name, searchResponse: .init(total_count: 0, incomplete_results: false, items: []), page: request.searchRequest.page, errorMessage: error.localizedDescription)
//                }
//            }
//            .disposed(by: disposeBag)
    }

}
