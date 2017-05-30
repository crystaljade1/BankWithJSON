//
//  JSONTest.swift
//  BankWithJSON
//
//  Created by Crystal Jade Allen-Washington on 5/2/17.
//  Copyright © 2017 Crystal Jade Allen-Washington. All rights reserved.
//

import Foundation

import XCTest
@testable import BankWithJSON

class Bank2Tests: XCTestCase {
    func testRoundTripFromJSON() {
        let bank = Bank(address: "1309 5th Avenue, New York, NY",
                        accountsDirectory: [:], employees: [])
        let result = bank(jsonObject: bank.jsonObject)
        XCTAssertEqual(result, bank)
    }

    func testRoundTriptoJSON() {
        let transaction = Account.Transaction(amount: 700.00, userDescription:
                            "vacation deposit",
                            vendor: "HausCall",
                            datePosted: nil)
        let result = Account.Transaction(jsonObject: transaction.jsonObject)
        
        XCTAssertEqual(result, transaction)
    }

}
