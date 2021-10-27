//
//  MasquePartyTests.swift
//  MasquePartyTests
//
//  Created by Isaiah Jenkins on 10/26/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import XCTest
import Firebase
import FirebaseFirestore
@testable import MasqueParty

class MasquePartyFirebaseTests: XCTestCase {

    var sut: Firestore!
    let networkMonitor = NetworkMonitor.shared
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = Firestore.firestore()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testCheckFieldExistsInDocument() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
        //given
        let field = "bio"
        let promise = expectation(description: "Completion handler invoked without error")
        var exists = false
        //when
        let docRef = sut.collection(K.FStore.usersCollection).document(K.FStore.currentUserId)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                XCTFail("Error: \(error?.localizedDescription ?? "")")
                return
            }
            print("document data", document?.data() ?? "No document")
            if let document = document, document.exists {
                
                if document.get(field) != nil {
                    exists = true
                    print("field exists")
                }else{
                    print("field nil")
                }
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        print("exists", exists)
        //then
        XCTAssertTrue(exists)
    }

}
