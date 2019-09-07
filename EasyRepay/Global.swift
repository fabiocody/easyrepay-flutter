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
    
    p = ModelHelper.newPerson(name: "Clay Jensen")
    p.transactions.append(ModelHelper.newTransaction(amount: 12.99, type: .debt, reason: "Pizza"))
    p.transactions.append(ModelHelper.newTransaction(amount: 15, type: .credit, reason: "Bike helmet"))
    ppl.people.append(p)
    
    p = ModelHelper.newPerson(name: "Justin Fooley")
    ppl.people.append(p)
    
    p = ModelHelper.newPerson(name: "Hannah Baker")
    p.transactions.append(ModelHelper.newTransaction(amount: 17.49, type: .debt, reason: "Tapes"))
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
