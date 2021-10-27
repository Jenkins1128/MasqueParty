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
            if let document = document, document.exists {
                if document.get(field) != nil {
                    exists = true
                }
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        //then
        XCTAssertTrue(exists)
    }
    
    func testSetDataForCurrentUser() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
        //given
        let key = "bio"
        let value = "test"
        let promise = expectation(description: "Completion handler invoked without error")
        var didSave = false
        //when
        let docRef = sut.collection(K.FStore.usersCollection).document(K.FStore.currentUserId)
        docRef.setData([
            key: value,
        ], merge: true) { error in
            guard error == nil else {
                XCTFail("Error: \(error?.localizedDescription ?? "")")
                return
            }
            didSave = true
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        //then
        XCTAssertTrue(didSave)
    }
    
    func testReadUserData() throws {
        try XCTSkipUnless(
            networkMonitor.isReachable,
            "Network connectivity needed for this test.")
        //given
        let promise = expectation(description: "Completion handler invoked without error")
        var dataReceived = false
        let uid = K.FStore.currentUserId
        //when
        let docRef = sut.collection(K.FStore.usersCollection).document(uid)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                XCTFail("Error: \(error?.localizedDescription ?? "")")
                return
            }
            if let document = document, document.exists {
                dataReceived = true
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        //then
        XCTAssertTrue(dataReceived)
    }
    
    func testQueryForUsersInLocation(){
        //given
        let promise = expectation(description: "Completion handler invoked without error")
        let currentLocation = "Apple Campus"
        var didQueryForUsers = false
        //when
        let docRef = sut.collection(K.FStore.usersCollection).whereField("postalCity", isEqualTo: currentLocation).limit(to: 20)
        docRef.getDocuments() { querySnapshot, error in
            guard error == nil else {
                XCTFail("Error: \(error?.localizedDescription ?? "")")
                return
            }
            if let snapshotDocuments = querySnapshot?.documents {
                for doc in snapshotDocuments {
                    let nearbyUserId = doc.documentID
                    if nearbyUserId != K.FStore.currentUserId {
                        didQueryForUsers = true;
                    }
                }
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        //then
        XCTAssertTrue(didQueryForUsers)
    }
    
    

}
