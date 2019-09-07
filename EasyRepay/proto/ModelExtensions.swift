//
//  ModelExtensions.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation
import Combine


final class UserData: ObservableObject {
    @Published var store: PeopleStore = peopleStore
}


extension PeopleStore {
    
    func save() {
        
    }
    
    func index(of person: Person) -> Int {
        for i in 0..<self.people.count {
            if self.people[i].id == person.id {
                return i
            }
        }
        return -1
    }
    
}


extension Person: Identifiable {
    
    init(name: String) {
        self.id = UUID().description
        self.name = name
    }
    
    func index(of transaction: Transaction) -> Int {
        for i in 0..<self.transactions.count {
            if self.transactions[i].id == transaction.id {
                return i
            }
        }
        return -1
    }
    
}



extension Transaction: Identifiable {
    
    init(type: TransactionType, amount: Double, note: String = "") {    // TODO There are actually more fields
        self.id = UUID().description
        self.type = type
        self.amount = amount
        self.note = note
        self.timestamp = UInt64(Date().timeIntervalSince1970)
    }
    
}
