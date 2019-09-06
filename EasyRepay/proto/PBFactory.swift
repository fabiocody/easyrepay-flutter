//
//  PBFactory.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation


class PBFactory {
    
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
    
}
