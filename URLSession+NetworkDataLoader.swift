//
//  URLSession+NetworkDataLoader.swift
//  iTunes Search
//
//  Created by Stephanie Ballard on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// protocol extension because we are conforming to the protocol at the same time

extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
