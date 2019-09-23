//
//  TransactionsList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionsList: View {
    
    @ObservedObject var person: Person
    
    @State private var showCompleted = false
        
    var body: some View {
        List {
            Section {
                Toggle("Show completed", isOn: $showCompleted.animation())
                Toggle("Activate reminder", isOn: $person.reminderActive.animation())
                if person.reminderActive {
                    Text("Reminders are not working at the moment.")
                        .foregroundColor(.red)
                }
            }
            if !person.transactions.isEmpty {
                Section {
                    ForEach(person.transactions) { transaction in
                        if self.showCompleted || !transaction.completed {
                            NavigationLink(destination: TransactionDetail(person: self.person, transaction: transaction)) {
                                TransactionRow(transaction: transaction, showCompleted: self.$showCompleted)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
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
        .listStyle(GroupedListStyle())
        .navigationBarTitle(person.name)
        .navigationBarItems(trailing: NavigationLink(destination: TransactionDetail(person: self.person, transaction: Transaction())) {
            HStack {
                Text("New transaction")
                Image(systemName: "plus.circle.fill")
                    .font(.title)
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        person.transactions.remove(atOffsets: offsets)
        dataStore.save()
    }
    
}


struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionsList(person: dataStore.people[0])
        }
        .accentColor(.green)
        .environment(\.colorScheme, .light)
    }
}
