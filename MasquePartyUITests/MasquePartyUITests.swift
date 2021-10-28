//
//  MasquePartyUITests.swift
//  MasquePartyUITests
//
//  Created by Isaiah Jenkins on 10/27/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import XCTest

class MasquePartyUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    func testTapNearbyUser() {
        //given
        app.collectionViews["nearbyUsersCollectionView"].cells.children(matching: .other).element.tap()
        let testName = "Bob Smith"
        let nameLabel = app.staticTexts[testName]
        //then
        XCTAssertTrue(nameLabel.exists)
    }
}
