//
//  Bank.swift
//  BankWithJSON
//
//  Created by Crystal Jade Allen-Washington on 5/2/17.
//  Copyright © 2017 Crystal Jade Allen-Washington. All rights reserved.
//

import Foundation

public class Bank {
    var bankAddress = "1309 5th Avenue, New York, NY 10029"
    
    var employees = Set<Employee>()
    
    func addNewEmployee(name: Employee) -> Bool {
        if employees.contains(name) {
            return false
        } else {
            employees.insert(name)
            return true
        }
    }

    var customers = [Customer]()
    let account: Account
    
    typealias AccountBalance = Double
    
    var accountBalance: AccountBalance {
        let accountBalance = account.balance
        return accountBalance
    }
    
    typealias TransactionType = Account.Transaction.TransactionType
    
    var transactionType: TransactionType
    
    typealias AccountDirectory = [UUID: AccountBalance]
    
    var accountDirectory: AccountDirectory
    
    init(account: Account, accountDirectory: [UUID: AccountBalance], transactionType: TransactionType) {
        self.account = account
        self.accountDirectory = accountDirectory
        self.transactionType = transactionType
    }
    
    func addNewCustomer(customer: Customer) -> Bool {
        guard customer.email != customer.email else {
            return false
        }
        
        customers.append(customer)
        return true
    }
    
    func createNewAccount(customer: Customer?, balance: AccountBalance, account: Account, accountType: Account.AccountType) -> Bool {
        guard customer != nil else {
            return false
        }
        
        customers.append(customer!)
        for (_, _) in accountDirectory {
            accountDirectory.updateValue(accountBalance, forKey: account.id)
        }
        return true
    }
    
    
    func makeCustomerTransaction(customer: Customer, amount: Double, accountType: Account.AccountType, transactionType: TransactionType, customerTransaction: Account.Transaction) -> Bool {
        
        guard customer.email == customer.email else {
            return false
        }
        
        switch transactionType {
        case .credit(amount: amount):
            guard amount.sign == .plus else {
                return false
            }
            for (_, _) in account.transactions {
                account.balance.add(amount)
                account.transactions.updateValue(amount, forKey: customerTransaction)
                return true
            }
        case .debit(amount: amount):
            guard amount < account.balance else {
                return false
            }
            for (_, _) in account.transactions {
                account.balance.subtract(amount)
                account.transactions.updateValue(amount, forKey: customerTransaction)
                return true
            }
        default:
            return false
        }
        
        return false
    }
    
    func getSpecificAccountBalance(accountDirectory: AccountDirectory, id: UUID) -> Double {
        let givenAccount = accountDirectory.filter { $0.key == id }
        let givenAccountBalance = givenAccount.reduce(0) { $0 + $1.1 }
        return givenAccountBalance
    }

    func getBalanceOfAllAccounts(accountDirectory: AccountDirectory) -> Double {
        let bankBalance = accountDirectory.reduce(0) { $0 + $1.1 }
        return bankBalance
    }
    
}
