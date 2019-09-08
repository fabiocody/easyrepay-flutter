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
    
    @State private var reminderActive = false
    @State private var showAdd = false
    @State private var showCompleted = false        // TODO Show completed
        
    var body: some View {
        List {
            Section {
                Toggle(isOn: $showCompleted.animation(), label: {Text("Show completed")})
                Toggle(isOn: $reminderActive.animation(), label: {Text("Activate reminder")})
                if reminderActive {
                    Text("This should only appear when the reminder is active.")
                }
            }
            Section {
                ForEach(person.transactions) { transaction in
                    NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                        TransactionRow(transaction: transaction)
                    }
                }
                .onDelete(perform: delete)
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
        //.sheet(isPresented: self.$showAdd, content: {NewTransactionView(pIdx: self.pIdx)})
        .sheet(isPresented: self.$showAdd, content: {NewTransactionView(person: self.person)})
    }
    
    func delete(at offsets: IndexSet) {
        person.transactions.remove(atOffsets: offsets)
        print(peopleStore)
    }
    
}


struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionsList(person: peopleStore.people[0])
        }
        .environment(\.colorScheme, .dark)
    }
}
