//
//  TransactionDetailView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @EnvironmentObject var data: UserData
    @Environment(\.presentationMode) var presentationMode
        
    var person: Person
    var transaction: Transaction
    
    var pIdx: Int {
        data.store.index(of: person)
    }
    
    var tIdx: Int {
        data.store.people[pIdx].index(of: transaction)
    }
    
    @State var typeSelection: Int = 0
    @State var amount: Double = 0
    @State var note: String = ""
    @State var date: Date = Date()
    
    var body: some View {
        TransactionDetail(typeSelection: $typeSelection, amount: $amount, note: $note, date: $date)
            .padding()
            .navigationBarTitle(Text("Transaction"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button("Save") {
                    self.data.store.people[self.pIdx].transactions[self.tIdx].type = TransactionType.allCases[self.typeSelection]
                    self.data.store.people[self.pIdx].transactions[self.tIdx].amount = self.amount
                    self.data.store.people[self.pIdx].transactions[self.tIdx].note = self.note
                    self.data.store.people[self.pIdx].transactions[self.tIdx].timestamp = UInt64(self.date.timeIntervalSince1970)
                    self.data.store.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                let t = self.transaction
                self.typeSelection = ModelHelper.enum2index(type: t.type)
                self.amount = t.amount
                self.note = t.note
                self.date = Date(timeIntervalSince1970: Double(t.timestamp))
            }
    }
    
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(person: peopleStore.people[0], transaction: peopleStore.people[0].transactions[0])
            .environment(\.colorScheme, .light)
            .environmentObject(UserData())
    }
}

