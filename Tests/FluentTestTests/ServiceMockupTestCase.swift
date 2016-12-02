//
//  DeviceTestCase.swift
//  GotYourBackServer
//
//  Created by Charlie Woloszynski on 10/20/16.
//
//

import XCTest
import Vapor
import HTTP
import Node
@testable import Fluent
@testable import FluentMySQL
import Turnstile

@testable import AppLogic

class ServiceMockupTestCase: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure  = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServerRunning() {
        
        let drop = try! configureDroplet()

        guard let database = drop.database else {
            XCTAssert(false,  "Database not initialized in droplet")
            return
        }

        for preparation in drop.preparations {
            // print("Preparing \(preparation.name)")
            XCTAssertNoThrow(try database.prepare(preparation))
            // print("Prepared \(preparation.name)")
        }
        
        let indexRequest = try! Request(method: .get, uri: "/")
        let indexResponse = try! drop.respond(to: indexRequest)
        XCTAssert(indexResponse.status == .ok)
        
        // Create post
        let entryRequest = try! Request(method: .post, uri: "/posts")
        entryRequest.headers = ["Content-Type" : "application/json"]
        entryRequest.body = JSON(["content": "Test content",
                                  "posted_on": "2016-10-12 8:00:00"]).makeBody()
        let entryResponse = try! drop.respond(to: entryRequest)
        XCTAssert(entryResponse.status == .ok)

    }

 /*    func testBasicSequenceWithTwoDevices() {
        
        return // FIXME: This is just to let this test run to completion
        
        let drop = try! configureDroplet()
  
        var user1 = User(username: "user1", password: "password")
        var user2 = User(username: "user2", password: "password")
        // FIXME:  This should be here from a user registration
        // var user1 = User(cloudKitRecordName: "XXX", firstName: "Charlie", lastName: "Wolo", admin: false)
        // var user2 = User(cloudKitRecordName: "YYY", firstName: "Quyen", lastName: "Duong", admin: false)
        do {
            try user1.save()
            try user2.save()
        } catch let error {
            print("Error saving user: \(error)")
        }
    
        // Create device #1
        let deviceOneRequest = try! Request(method: .post, uri: "/v1/devices")
        deviceOneRequest.headers = ["Content-Type" : "application/json"]
        deviceOneRequest.body = JSON(["udid": "ABC",
                                     "deviceName": "name",
                                     "deviceModel": "iPhone 5c",
                                     "user_id" : user1.id!,
                                     "createdAt": "2016-10-31 12:00:00",
                                     "updatedAt": "2016-10-12 8:00:00"]).makeBody()
        let deviceOneResponse = try! drop.respond(to: deviceOneRequest)
        XCTAssert(deviceOneResponse.status == .ok)

        // Create device #1's APNS details
        XCTAssertNotNil(deviceOneResponse.json)
        XCTAssertNotNil(deviceOneResponse.json!["id"])
        XCTAssertNotNil(deviceOneResponse.json!["id"]!.int)
        let deviceOneId = deviceOneResponse.json!["id"]!.int!
        let pushDetailOneRequest = try! Request(method: .post, uri: "/v1/devices/\(deviceOneId)/pushDetails")
        pushDetailOneRequest.headers = ["Content-Type" : "application/json"]
        pushDetailOneRequest.body = JSON(["deviceToken": "DEADBEEF",
                                          "notificationType": "APNS"]).makeBody()
        let pushDetailOneResponse = try! drop.respond(to: pushDetailOneRequest)
        XCTAssert(pushDetailOneResponse.status == .ok)
       
        
        // Create device #2
        let deviceTwoRequest = try! Request(method: .post, uri: "/v1/devices")
        deviceTwoRequest.headers = ["Content-Type" : "application/json"]
        deviceTwoRequest.body = JSON(["udid": "XYZ",
                                      "deviceName": "name",
                                      "deviceModel": "iPhone 5s",
                                      "user_id" : user2.id!,
                                      "createdAt": "2016-10-31 12:00:00",
                                      "updatedAt": "2016-10-12 8:00:00"]).makeBody()
        let deviceTwoResponse = try! drop.respond(to: deviceTwoRequest)
        XCTAssert(deviceTwoResponse.status == .ok)

        // Create device #2's APNS details
        XCTAssertNotNil(deviceTwoResponse.json)
        XCTAssertNotNil(deviceTwoResponse.json!["id"])
        XCTAssertNotNil(deviceTwoResponse.json!["id"]!.int)
        let deviceTwoId = deviceTwoResponse.json!["id"]!.int!
        let pushDetailTwoRequest = try! Request(method: .post, uri: "/v1/devices/\(deviceTwoId)/pushDetails")
        pushDetailTwoRequest.headers = ["Content-Type" : "application/json"]
        pushDetailTwoRequest.body = JSON(["deviceToken": "ABBAABBA",
                                          "notificationType": "APNS"]).makeBody()
        let pushDetailTwoResponse = try! drop.respond(to: pushDetailTwoRequest)
        XCTAssert(pushDetailTwoResponse.status == .ok)
        
        // Create an outing
        let outingOneRequest = try! Request(method: .post, uri: "/v1/outings")
        outingOneRequest.headers = ["Content-Type" : "application/json"]
        outingOneRequest.body = JSON(["startedAt": "2016-11-01 8:00:00",
                                      "user_id": user1.id!, // FIXME: This should be really provided by user auth
                                          "arrivalDeadline": "2016-11-01 10:00:00"]).makeBody()
        let outingOneResponse = try! drop.respond(to: outingOneRequest)
        XCTAssert(outingOneResponse.status == .ok)
      
        XCTAssertNotNil(outingOneResponse.json)
        XCTAssertNotNil(outingOneResponse.json!["id"])
        XCTAssertNotNil(outingOneResponse.json!["id"]!.int)
        let outingOneIdAsNode = outingOneResponse.json!["id"]!
       
        // Create an observer for outing on device #1
        let observerRequest = try! Request(method: .post, uri: "/v1/devices/\(deviceTwoId)/observations")
        observerRequest.headers = ["Content-Type" : "application/json"]
        observerRequest.body = JSON(["outing_id": outingOneIdAsNode]).makeBody()
        let observerResponse = try! drop.respond(to: observerRequest)
        XCTAssert(observerResponse.status == .ok)
       
        // Cancel an outing
        let outingOneId = outingOneIdAsNode.int!
        let cancelRequest = try! Request(method: .patch , uri: "/v1/devices/\(deviceOneId)/outings/\(outingOneId)")
        cancelRequest.headers = ["Content-Type" : "application/json"]
        cancelRequest.body = JSON(["cancelledAt": "2016-11-01 8:01:00"]).makeBody()
        let cancelResponse = try! drop.respond(to: cancelRequest)
        XCTAssert(cancelResponse.status == .ok)

        // Verify error if trying to complete an outing that is already cancelled
        let completeRequest = try! Request(method: .patch , uri: "/v1/devices/\(deviceOneId)/outings/\(outingOneId)")
        completeRequest.headers = ["Content-Type" : "application/json"]
        completeRequest.body = JSON(["completedAt": "2016-11-01 8:01:00"]).makeBody()
        let completeResponse = try! drop.respond(to: completeRequest)
        XCTAssert(completeResponse.status == .badRequest)
        
        
    } */
}
