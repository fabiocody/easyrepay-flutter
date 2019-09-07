//
//  ModelHelper.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation


class ModelHelper {
    
    static func insertPerson(name: String) {
        let p = Person(name: name)
        peopleStore.people.append(p)
        peopleStore.people.sort(by: {$0.name < $1.name})
    }
        
    static func insertTransaction(_ transaction: Transaction, person: Person) {
        let personIndex = peopleStore.index(of: person)
        peopleStore.people[personIndex].transactions.append(transaction)
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
