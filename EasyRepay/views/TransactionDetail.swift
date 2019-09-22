//
//  TransactionDetail.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
        
    @ObservedObject var person: Person
    @ObservedObject var transaction: Transaction
    
    @State var typeSelection: Int = 0
    @State var amount: Double? = nil
    @State var note: String = ""
    @State var date: Date = Date()
    @State var completed: Bool = false
    
    var body: some View {
        Form {
            Toggle("Completed", isOn: $completed)
            Picker(selection: $typeSelection, label: Text("Type")) {
                ForEach(0..<TransactionType.allCases.count) {
                    Text(TransactionType.allCases[$0].rawValue).tag($0)
                        .accentColor(.green)
                }
            }
            .accentColor(.green)
            HStack(alignment: .center) {
                Text("Amount")
                Spacer()
                TextField("Enter amount", value: $amount, formatter: currencyFormatter, onEditingChanged: {
                    if $0 && self.amount == 0 {
                        self.amount = nil
                    }
                })
                .keyboardType(.numbersAndPunctuation)
                .lineLimit(5)
                .multilineTextAlignment(.trailing)
            }
            HStack(alignment: .center) {
                Text("Note")
                Spacer()
                TextField("Enter note", text: $note)
                    .multilineTextAlignment(.trailing)
            }
            DatePicker(selection: $date.animation(), label: {Text("Date")})
        }
        .navigationBarTitle(Text("Transaction"), displayMode: .inline)
        .navigationBarItems(
            trailing: Button("Save") {
                self.transaction.type = TransactionType.allCases[self.typeSelection]
                self.transaction.amount = self.amount ?? 0.0
                self.transaction.note = self.note == "" ? "New transaction" : self.note
                self.transaction.date = self.date
                self.transaction.completed = self.completed
                if !self.person.transactions.contains(where: {$0.id == self.transaction.id}) {
                    self.person.transactions.append(self.transaction)
                }
                dataStore.save()
                self.person.updateTotalAmount()
                self.presentationMode.wrappedValue.dismiss()
            }
        )
        .onAppear {
            let t = self.transaction
            self.typeSelection = t.type.index
            self.amount = t.amount
            self.note = t.note
            self.date = t.date
            self.completed = t.completed
        }
    }
    
}

struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionDetail(person: dataStore.people[0], transaction: dataStore.people[0].transactions[0])
                .environment(\.colorScheme, .light)
        }
    }
}

