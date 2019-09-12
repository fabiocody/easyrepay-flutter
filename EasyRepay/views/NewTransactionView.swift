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
    @State private var completed: Bool = false
    
    var body: some View {
        NavigationView {
            TransactionDetail(typeSelection: $typeSelection, amount: $amount, note: $note, date: $date, completed: $completed)
                .padding(.top, 10)
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
                        let t = Transaction(type: TransactionType.allCases[self.typeSelection],
                                            amount: self.amount ?? 0.0,
                                            note: self.note == "" ? "New transaction" : self.note,
                                            completed: self.completed)
                        self.person.transactions.append(t)
                        self.person.sortTransactions()
                        peopleStore.save()
                        self.person.updateTotalAmount()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .accentColor(.green)
                )
                .accentColor(.green)
        }
        .accentColor(.green)
        .onAppear {
            self.typeSelection = 0
            self.amount = nil
            self.note = ""
            self.date = Date()
            self.completed = false
        }
    }
    
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView(person: peopleStore.people[0])
            .environment(\.colorScheme, .light)
    }
}
