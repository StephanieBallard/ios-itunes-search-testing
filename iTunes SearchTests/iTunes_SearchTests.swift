//
//  iTunes_SearchTests.swift
//  iTunes SearchTests
//
//  Created by Stephanie Ballard on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import iTunes_Search

/*
 
 Does decoding work?
 Does decoding fail when given bad data?
 Does it build the correct URL?
 Does it build the correct URLRequest?
 Are the search results saved properly?
 Is the completion handler called when data is good?
 Is the completion handler called when data is bad?
 Is the completion handler called when networking fails?
 */


class iTunes_SearchTests: XCTestCase {
    
    func testForSomeResults() {
        // this is testing our code and the server's code
        // Create an expectation
        let expectation = self.expectation(description: "Wait for results")
        // Create a controller
        let controller = SearchResultController()
        // Create some work to happen on a different queue then go down to the next line, need to wait for the expectation
        controller.performSearch(for: "GarageBand", resultType: .software) {
            print("We got back some results!")
            XCTAssertGreaterThan(controller.searchResults.count, 0)
            expectation.fulfill()
        }
        // then we wait until the expectation is satisfied
        wait(for: [expectation], timeout: 5)
        
        XCTAssertGreaterThan(controller.searchResults.count, 0)
    }
    
    func testSpeedOfTypicalRequest() {
        // can only have one measure block per test
        measure {
            let expectation = self.expectation(description: "Wait for results")
            let controller = SearchResultController(dataLoader: URLSession(configuration: .ephemeral))
            
            controller.performSearch(for: "GarageBand", resultType: .software) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testSpeedOfTypicalRequestMoreAccurately() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            let expectation = self.expectation(description: "Wait for results")
            let controller = SearchResultController(dataLoader: URLSession(configuration: .ephemeral))
            
            startMeasuring()
            controller.performSearch(for: "GarageBand", resultType: .software) {
                self.stopMeasuring()
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
    }
    
    func testValidData() {
        let mockDataLoader = MockDataLoader(data: goodResultData, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            
            XCTAssertEqual(controller.searchResults.count, 2, "Expected 2 results for \"GarageBand\"")
            
            let firstResult = controller.searchResults[0]
            XCTAssertEqual(firstResult.title, "GarageBand")
            XCTAssertEqual(firstResult.artist, "Apple")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testInvalidData() {
        let mockDataLoader = MockDataLoader(data: badJSONData, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "GarageBand", resultType: .software) {
            
            XCTAssertEqual(controller.searchResults.count, 0, "Expected 0 results for \"GarageBand\"")
            XCTAssertTrue(controller.searchResults.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testNoResultsData() {
        let mockDataLoader = MockDataLoader(data: noResultsData, response: nil, error: nil)
        
        let expectation = self.expectation(description: "Wait for results")
        let controller = SearchResultController(dataLoader: mockDataLoader)
        
        controller.performSearch(for: "giggiigygiytdx", resultType: .software) {
            
            XCTAssertEqual(controller.searchResults.count, 0, "Expected 0 results for \"giggiigygiytdx\"")
            XCTAssertTrue(controller.searchResults.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

