//
//  NewTransactionView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var person: Person
    
    @State private var typeSelection: Int = 0
    @State private var amount: Double? = nil
    @State private var note: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationView {
            TransactionDetail(typeSelection: $typeSelection, amount: $amount, note: $note, date: $date)
                .padding()
                .navigationBarTitle("New transaction")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        self.typeSelection = 0
                        self.amount = 0
                        self.note = ""
                        self.date = Date()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .accentColor(.green)
                    , trailing: Button("Save") {
                        let t = Transaction(type: TransactionType.allCases[self.typeSelection], amount: self.amount ?? 0.0, note: self.note)
                        self.person.transactions.append(t)
                        self.person.transactions.sort(by: {$0.date < $1.date})
                        peopleStore.save()
                        self.person.updateTotalAmount()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .accentColor(.green)
                )
                .accentColor(.green)
        }
    }
    
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView(person: peopleStore.people[0])
            .environment(\.colorScheme, .light)
    }
}
