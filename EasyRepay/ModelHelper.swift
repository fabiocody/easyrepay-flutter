//
//  ModelHelper.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation


class ModelHelper {
    
    static func newPerson(name: String) -> Person {
        var p = Person()
        p.id = UUID().description
        p.name = name
        return p
    }
    
    static func newTransaction(amount: Double, type: TransactionType, reason: String = "") -> Transaction {
        var t = Transaction()
        t.id = UUID().description
        t.amount = amount
        t.type = type
        t.reason = reason
        t.timestamp = UInt64(Date().timeIntervalSince1970)
        return t
    }
    
    static func insertPerson(name: String) {
        let p = newPerson(name: name)
        peopleStore.people.append(p)
        peopleStore.people.sort(by: {$0.name < $1.name})
    }
    
    static func index(of person: Person) -> Int {
        for i in 0..<peopleStore.people.count {
            if peopleStore.people[i] == person {
                return i
            }
        }
        return -1
    }
    
    static func index(of transaction: Transaction, in person: Person) -> Int {
        for i in 0..<person.transactions.count {
            if person.transactions[i] == transaction {
                return i
            }
        }
        return -1
    }
    
    static func enum2string(type: TransactionType) -> String {
        switch type {
        case .credit:
            return "Credit"
        case .debt:
            return "Debt"
        case .settleCredit:
            return "Settle credit"
        case .settleDebt:
            return "Settle debt"
        case .undef:
            return "---"
        default:
            return ""
        }
    }
    
    static func enum2index(type: TransactionType) -> Int {
        switch type {
        case .credit:
            return 1
        case .debt:
            return 2
        case .settleCredit:
            return 3
        case .settleDebt:
            return 4
        default:
            return 0
        }
    }
    
}
