//
//  TransactionsList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionsList: View {
    
    @ObservedObject var store = peopleStore
    @ObservedObject var person: Person
    
    @State private var reminderActive = false
    @State private var showAdd = false
    @State private var showCompleted = false        // TODO Show completed
        
    var body: some View {
        List {
            Section {
                Toggle("Show completed", isOn: $showCompleted.animation())
                Toggle("Activate reminder", isOn: $reminderActive.animation())
                if reminderActive {
                    Text("This should only appear when the reminder is active.")
                }
            }
            Section {
                ForEach(person.transactions) { transaction in
                    if self.showCompleted || !transaction.completed {
                        NavigationLink(destination: TransactionDetailView(person: self.person, transaction: transaction)) {
                            TransactionRow(transaction: transaction, showCompleted: self.$showCompleted)
                        }
                    }
                }
                .onDelete(perform: delete)
                if person.transactions.isEmpty {
                    HStack {
                        Spacer()
                        Text("Nothing to show here")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            if !person.transactions.isEmpty {
                Section {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("\(currencyFormatter.string(for: abs(person.totalAmount))!)")
                            .foregroundColor(Colors.amountColor(person: person))
                            .padding(.trailing, 17)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(person.name)
        .navigationBarItems(trailing: Button(action: {
            self.showAdd = true
        }) {
            HStack {
                Text("New transaction")
                Image(systemName: "plus.circle.fill")
                    .font(.title)
            }
        })
        .sheet(isPresented: self.$showAdd, content: {NewTransactionView(person: self.person)})
    }
    
    func delete(at offsets: IndexSet) {
        person.transactions.remove(atOffsets: offsets)
        store.save()
    }
    
}


struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionsList(person: peopleStore.people[0])
        }
        .accentColor(.green)
        .environment(\.colorScheme, .light)
    }
}
