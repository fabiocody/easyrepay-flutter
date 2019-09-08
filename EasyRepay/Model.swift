//
//  Model.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 08/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation


class PeopleStore: ObservableObject {
    @Published var people: [Person] = []
    
    private var fileURL: URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("people.bin")
    }
    
    func save() {
        /*do {
            try self.serializedData().write(to: fileURL)
            print("Save successful")
        } catch {
            print("ERROR: save")
            print(error)
        }*/
    }
    
    func read() {
        /*do {
            try self.merge(serializedData: Data(contentsOf: fileURL))
            print("Read successful")
        } catch {
            print("ERROR: read")
            print(error)
        }*/
    }
}


class Person: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var transactions: [Transaction] = []
    @Published var reminderActive = false
    @Published var reminderDate: Date?
    
    init(name: String) {
        self.name = name
    }
    
    var totalAmount: Double {
        transactions.map({$0.amount}).reduce(0, +)
    }
    
    var protobuf: PBPerson {
        // TODO
        PBPerson()
    }
}


class Transaction: Identifiable, ObservableObject {
    let id = UUID()
    @Published var type: TransactionType
    @Published var amount: Double
    @Published var note: String
    @Published var completed = false
    @Published var date: Date
    
    init(type: TransactionType = .undef, amount: Double, note: String = "", date: Date = Date()) {
        self.type = type
        self.amount = amount
        self.note = note
        self.date = date
    }
    
    var protobuf: PBTransaction {
        // TODO
        PBTransaction()
    }
}


enum TransactionType: String, CaseIterable {
    case undef = "---"
    case credit = "Credit"
    case settleDebt = "Settle debt"
    case debt = "Debt"
    case settleCredit = "Settle credit"
    
    var index: Int {
        for i in 0..<TransactionType.allCases.count {
            if TransactionType.allCases[i] == self {
                return i
            }
        }
        return -1
    }
    
    var protobuf: PBTransactionType {
        // TODO
        .undef
    }
}
