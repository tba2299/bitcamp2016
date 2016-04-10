//
//  bitcamp2016Tests.swift
//  bitcamp2016Tests
//
//  Created by Nick LoBue on 4/8/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import XCTest
@testable import bitcamp2016

class bitcamp2016Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let provider = MusicMetadataProvider()
        provider.getLocalArtistData()
        sleep(5) // allow artist data to get retrieved
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
