//
//  Account.swift
//  BankWithJSON
//
//  Created by Crystal Jade Allen-Washington on 5/2/17.
//  Copyright © 2017 Crystal Jade Allen-Washington. All rights reserved.
//

import Foundation

public class Account {
    enum AccountType {
        case checking
        case savings
    }
    
    let id: UUID
    var balance: Double
    
    init(id: UUID, balance: Double) {
        self.id = id
        self.balance = balance
    }
    
    var transactions: [Transaction: Double] = [:]
    
    public struct Transaction: Hashable {
        
        public var hashValue: Int {
            let transaction: Transaction
            return transaction.hashValue
        }
        
        public static func == (_ lhs: Transaction, _ rhs: Transaction) -> Bool {
            return (lhs.amount == rhs.amount &&
                lhs.dateCreated == rhs.dateCreated &&
                lhs.datePosted == rhs.datePosted &&
                lhs.vendor == rhs.vendor &&
                lhs.userDescription == rhs.userDescription)
        }
        
        enum TransactionType {
            case debit(amount: Double)
            case credit(amount: Double)
        }
        
        let amount: Double
        var userDescription: String?
        let vendor: String
        var datePosted: Date?
        let dateCreated: Date
        static func sanitize(date: Date) -> Date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            return calendar.date(from: components)!
        }
        
        public init(amount: Double,
                    userDescription: String?,
                    vendor: String,
                    datePosted: Date?) {
            self.init(amount: amount, userDescription: userDescription,
                      vendor: vendor,
                      datePosted: datePosted,
                      dateCreated: Date())
        }
        
        internal init(amount: Double,
                      userDescription: String?,
                      vendor: String,
                      datePosted: Date?,
                      dateCreated: Date) {
            self.amount = amount
            self.userDescription = userDescription
            self.vendor = vendor
            self.datePosted = datePosted.map(Account.Transaction.sanitize(date: ))
            self.dateCreated = Account.Transaction.sanitize(date: dateCreated)
        }
    }
}

extension Account: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Account {
    convenience init?(jsonObject: [String: Any]) {
        return nil
    }
    
    var jsonObject: [String: Any] {
        return [:]
    }
}

extension Account.Transaction {
    init?(jsonObject: [String: Any]) {
        guard let amount = jsonObject[Account.Transaction.dateCreatedKey] as? Double,
            let dateCreatedAsDouble = jsonObject[Account.Transaction.dateCreatedKey] as? Double,
            let vendor = jsonObject[Account.Transaction.vendorKey] as? String
            else {
                return nil
        }
        
        let dateCreated = Date(timeIntervalSince1970: dateCreatedAsDouble)
        let userDescription = jsonObject[Account.Transaction.datePostedKey] as? String
        let datePosted = datePostedString.flatMap(Account.Transaction.dateFormatted.date(from:))
        self.init(amount: amount, userDescription: userDescription, vendor: vendor, datePosted: datePosted, dateCreated: dateCreated)
    }
    
    var jsonObject: [String: Any] {
        var back: [String: Any] = [
            Account.Transaction.amountKey : amount,
            Account.Transaction.dateCreatedKey: dateCreated.timeIntervalSince1970,
            Account.Transaction.datePostedKey: datePosted.map(Account.Transaction.dateFormatter.string(from:)) as Any,
            Account.Transaction.vendorKey: vendor,
            ]
        
        if let description = userDescription {
            back[Account.Transaction.userDescriptionKey] = description
        }
        
        return back

    }
    
    internal static var amountKey: String = "amount"
    internal static var dateCreatedKey: String = "date_created"
    internal static var datePostedKey: String = "date_posted"
    internal static var vendorKey: String = "vendor"
    internal static var userDescriptionKey: String = "user_description"

}
