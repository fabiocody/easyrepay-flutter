//
//  Global.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import Foundation


#if DEBUG
var peopleStore: PeopleStore = {
    var ppl = PeopleStore()
    var p: Person
    var t: Transaction
    
    p = Person(name: "Clay Jensen")
    p.transactions.append(Transaction(type: .debt, amount: 12.99, note: "Pizza"))
    p.transactions.append(Transaction(type: .credit, amount: 15, note: "Bike helmet"))
    ppl.people.append(p)
    
    p = Person(name: "Justin Fooley")
    ppl.people.append(p)
    
    p = Person(name: "Hannah Baker")
    p.transactions.append(Transaction(type: .debt, amount: 17.49, note: "Tapes"))
    ppl.people.append(p)
    
    ppl.people.sort(by: {$0.name < $1.name})
    
    return ppl
}()
#endif


let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    //formatter.positiveFormat = "¤ #,##0.00"
    //formatter.negativeFormat = "¤ -#,##0.00"
    return formatter
}()


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
