//
//  Model.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 08/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation
import Combine


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
    @Published var transactions: [Transaction] = [] {
        didSet { updateTotalAmount() }
    }
    @Published var reminderActive = false
    @Published var reminderDate: Date?
    
    @Published var totalAmount = 0.0

    
    init(name: String) {
        self.name = name
    }
    
    var protobuf: PBPerson {
        // TODO
        PBPerson()
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    func updateTotalAmount() {
        //print("UPDATING TOTAL AMOUNT")
        var sum = 0.0
        for t in transactions {
            switch t.type {
            case .credit, .settleDebt:
                sum += t.amount
            case .debt, .settleCredit:
                sum -= t.amount
            default:
                sum += 0
            }
        }
        totalAmount = sum
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
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
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
