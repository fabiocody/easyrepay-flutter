//
//  Model.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 08/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation
import Combine


class DataStore: ObservableObject {
    @Published var people: [Person] = []
    @Published var settings: Settings = Settings()
    
    private var fileURL: URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("people.pb")
    }
    
    func save() {
        var pbstore = PBDataStore()
        for p in people {
            pbstore.people.append(p.protobuf)
        }
        print(pbstore)
        do {
            try pbstore.serializedData().write(to: fileURL)
            print("Save successful")
        } catch {
            print("ERROR: save")
            print(error)
        }
    }
    
    func read() {
        var pbstore = PBDataStore()
        do {
            try pbstore.merge(serializedData: Data(contentsOf: fileURL))
            print("Read successful")
            for p in pbstore.people {
                people.append(Person(pbperson: p))
            }
        } catch {
            print("ERROR: read")
            print(error)
        }
    }
    
    func sortPeople() {
        people.sort(by: {$0.name < $1.name})
    }
}


class Person: Identifiable, ObservableObject {
    var id = UUID()
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
    
    init(pbperson: PBPerson) {
        id = UUID(uuidString: pbperson.id)!
        name = pbperson.name
        reminderActive = pbperson.reminderActive
        reminderDate = Date(timeIntervalSince1970: TimeInterval(pbperson.reminderTimestamp))
        transactions = []
        for t in pbperson.transactions {
            transactions.append(Transaction(pbtransaction: t))
        }
        updateTotalAmount()
    }

    var protobuf: PBPerson {
        var p = PBPerson()
        p.id = id.description
        p.name = name
        p.reminderActive = reminderActive
        if let date = reminderDate {
            p.reminderTimestamp = UInt64(date.timeIntervalSince1970)
        }
        for t in transactions {
            p.transactions.append(t.protobuf)
        }
        return p
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
            }
        }
        totalAmount = sum
    }
    
    func sortTransactions() {
        transactions.sort(by: {$0.date < $1.date})
    }
}


class Transaction: Identifiable, ObservableObject {
    var id = UUID()
    @Published var type: TransactionType
    @Published var amount: Double
    @Published var note: String
    @Published var completed = false
    @Published var date: Date
    
    init(type: TransactionType = .credit, amount: Double, note: String = "", date: Date = Date(), completed: Bool = false) {
        self.type = type
        self.amount = amount
        self.note = note
        self.date = date
        self.completed = completed
    }
    
    init(pbtransaction: PBTransaction) {
        id = UUID(uuidString: pbtransaction.id)!
        type = pbtransaction.type.native
        amount = pbtransaction.amount
        note = pbtransaction.note
        completed = pbtransaction.completed
        date = Date(timeIntervalSince1970: TimeInterval(pbtransaction.timestamp))
    }

    var protobuf: PBTransaction {
        var t = PBTransaction()
        t.id = id.description
        t.type = type.protobuf
        t.amount = amount
        t.note = note
        t.completed = completed
        t.timestamp = UInt64(date.timeIntervalSince1970)
        return t
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
}


enum TransactionType: String, CaseIterable, Identifiable {
    case credit = "Credit"
    case settleDebt = "Settle debt"
    case debt = "Debt"
    case settleCredit = "Settle credit"
    
    var id: Int { index }
    
    var index: Int {
        for i in 0..<TransactionType.allCases.count {
            if TransactionType.allCases[i] == self {
                return i
            }
        }
        return -1
    }
    
    var protobuf: PBTransactionType {
        switch self {
        case .credit:
            return .credit
        case .debt:
            return .debt
        case .settleCredit:
            return .settleCredit
        case .settleDebt:
            return .settleDebt
        }
    }
}


extension PBTransactionType {
    var native: TransactionType {
        switch self {
        case .credit:
            return .credit
        case .debt:
            return .debt
        case .settleCredit:
            return .settleCredit
        case .settleDebt:
            return .settleDebt
        default:
            return .credit
        }
    }
}


class Settings: ObservableObject {
    
    @Published var icloud = false
    
}
