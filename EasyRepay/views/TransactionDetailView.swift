//
//  TransactionDetailView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
        
    @ObservedObject var transaction: Transaction
    
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
                    self.transaction.type = TransactionType.allCases[self.typeSelection]
                    self.transaction.amount = self.amount
                    self.transaction.note = self.note
                    self.transaction.date = self.date
                    peopleStore.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                let t = self.transaction
                self.typeSelection = t.type.index
                self.amount = t.amount
                self.note = t.note
                self.date = t.date
            }
    }
    
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(transaction: peopleStore.people[0].transactions[0])
            .environment(\.colorScheme, .light)
    }
}

