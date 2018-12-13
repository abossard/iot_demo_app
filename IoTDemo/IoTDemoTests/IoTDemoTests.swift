//
//  IoTDemoTests.swift
//  IoTDemoTests
//
//  Created by andre on 10.12.18.
//  Copyright © 2018 Bossdev. All rights reserved.
//

import XCTest


class IoTDemoTests: XCTestCase {
    var input: String!
    override func setUp() {
        self.input = """
[
  {
    "time": null,
    "tmms": 0,
    "tmst": 3578899419,
    "freq": 868.3,
    "chan": 1,
    "rfch": 1,
    "stat": 1,
    "modu": "LORA",
    "datr": "SF7BW125",
    "codr": "4/5",
    "rssi": -33,
    "lsnr": 9.8,
    "size": 17,
    "data": {
      "messageType": 1,
      "deviceType": 1,
      "waterLevel": 0,
      "waterPresence": 151,
      "soilHumidity": 0,
      "battery": 3,
      "charging": false
    },
    "port": 8,
    "fcnt": 1831,
    "eui": "5555C86800430011",
    "gatewayid": "swissre-iotedge",
    "edgets": 1544543232715
  },
  {
    "time": null,
    "tmms": 0,
    "tmst": 3578720411,
    "freq": 868.3,
    "chan": 1,
    "rfch": 1,
    "stat": 1,
    "modu": "LORA",
    "datr": "SF7BW125",
    "codr": "4/5",
    "rssi": -101,
    "lsnr": 6,
    "size": 21,
    "data": {
      "messageType": 2,
      "deviceType": 2,
      "lat": 47.40869879722595,
      "lng": 8.590879440307617
    },
    "port": 10,
    "fcnt": 140,
    "eui": "5555C86800430012",
    "gatewayid": "swissre-iotedge",
    "edgets": 1544543232536
  }
]
"""
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let decoder = JSONDecoder()
        try self.decoder.decode(DeviceServiceMessage.self, from: self.data)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
