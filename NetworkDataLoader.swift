//
//  NetworkDataLoader.swift
//  iTunes Search
//
//  Created by Stephanie Ballard on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}
