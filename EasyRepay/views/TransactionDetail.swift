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
    @State var amountText: String = ""
    @State var note: String = ""
    @State var date: Date = Date()
    @State var completed: Bool = false
    
    var body: some View {
        Form {
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
                TextField("Enter amount", text: $amountText, onEditingChanged: onEditingChanged)
                    .keyboardType(.decimalPad)
                    .lineLimit(5)
                    .multilineTextAlignment(.trailing)
            }
            HStack(alignment: .center) {
                Text("Note")
                Spacer()
                TextField("Enter note", text: $note, onEditingChanged: {
                    if $0 && self.note == "New transaction" {
                        self.note = ""
                    }
                })
                .multilineTextAlignment(.trailing)
            }
            Toggle("Completed", isOn: $completed)
            DatePicker(selection: $date.animation(), label: {Text("Date")})
        }
        .navigationBarTitle(Text("Transaction"), displayMode: .inline)
        .navigationBarItems(
            trailing: Button("Save") {
                self.transaction.type = TransactionType.allCases[self.typeSelection]
                self.onEditingChanged()
                self.transaction.amount = currencyFormatter.number(from: self.amountText) as? Double ?? 0.0
                self.transaction.note = self.note == "" ? "New transaction" : self.note
                self.transaction.date = self.date
                self.transaction.completed = self.completed
                if !self.person.transactions.contains(where: {$0.id == self.transaction.id}) {
                    self.person.transactions.append(self.transaction)
                }
                dataStore.save()
                self.person.updateTotalAmount()
                self.person.sortTransactions()
                self.presentationMode.wrappedValue.dismiss()
            }
        )
        .onAppear {
            let t = self.transaction
            self.typeSelection = t.type.index
            self.amountText = currencyFormatter.string(for: t.amount)!
            self.note = t.note
            self.date = t.date
            self.completed = t.completed
        }
    }
    
    // This method is required because the TextField implementation with formatter sucks.
    // It basically mimics the presence of a formatter
    func onEditingChanged(_ editing: Bool = false) {
        print("onEditingChanged \(editing)")
        if let value = currencyFormatter.number(from: amountText) as? Double {
            if editing {
                if value == 0 {
                    amountText = ""
                } else {
                    amountText = numberFormatter.string(for: value)!
                }
            } else {
                amountText = currencyFormatter.string(for: value)!
            }
        } else {
            amountText = currencyFormatter.string(for: 0.0)!
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

