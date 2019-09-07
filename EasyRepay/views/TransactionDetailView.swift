//
//  TransactionDetailView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct TransactionDetailView: View {
    
    var person: Person
    var transactionIndex: Int
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var typeSelection: Int = 0
    @State var amount: Double = 0
    @State var reason: String = ""
    @State var date: Date = Date()
    
    var body: some View {
        TransactionDetail(typeSelection: $typeSelection, amount: $amount, reason: $reason, date: $date)
            .padding()
            .navigationBarTitle(Text("Transaction"), displayMode: .inline)
            //.navigationBarTitle("Transaction")
            .navigationBarItems(
                trailing: Button("Save") {
                    // TODO
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                let t = self.person.transactions[self.transactionIndex]
                self.typeSelection = ModelHelper.enum2index(type: t.type)
                self.amount = t.amount
                self.reason = t.reason
                self.date = Date(timeIntervalSince1970: Double(t.timestamp))
            }
    }
    
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionDetailView(person: peopleStore.people[0], transactionIndex: 0)
                .environment(\.colorScheme, .light)
            TransactionDetailView(person: peopleStore.people[0], transactionIndex: 0)
                .environment(\.colorScheme, .dark)
        }
    }
}

