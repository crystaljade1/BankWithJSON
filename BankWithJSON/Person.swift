//
//  Person.swift

//  BankWithJSON
//
//  Created by Crystal Jade Allen-Washington on 5/30/17.
//  Copyright © 2017 Crystal Jade Allen-Washington. All rights reserved.
//

import Foundation

public class Person: Hashable {
    
    var givenName: String
    var familyName: String
    var fullName: String {
        let fullName = "\(givenName) + \(familyName)"
        return fullName
    }
    
    init(givenName: String, familyName: String) {
        self.givenName = givenName
        self.familyName = familyName
    }
    
    public var hashValue: Int {
        let person = Person(givenName: givenName, familyName: familyName)
        return person.hashValue
    }
    
    public static func == (_ lhs: Person, _ rhs: Person) -> Bool {
        return (lhs.givenName == rhs.givenName) && (lhs.familyName == rhs.familyName)
    }
    
}

class Employee: Person {
    
}

class Customer: Person {
    var email: String
    var accounts: [Account]
    
    init(email: String, accounts: [Account], givenName: String, familyName: String) {
        self.email = email
        self.accounts = accounts
        super.init(givenName: givenName, familyName: familyName)
        self.givenName = givenName
        self.familyName = familyName
    }
}
