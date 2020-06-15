//
//  MockDataLoading.swift
//  iTunes SearchTests
//
//  Created by Stephanie Ballard on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
@testable import iTunes_Search

class MockDataLoader: NetworkDataLoader {
    // command click on the class generate memberwise init
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    internal init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            completion(self.data, self.response, self.error)
        }
    }
}
