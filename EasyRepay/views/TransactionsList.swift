//
//  TransactionsList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionsList: View {
    
    @EnvironmentObject var data: UserData
    
    let person: Person
    
    var pIdx: Int {
        data.store.index(of: person)
    }
    
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
                ForEach(data.store.people[pIdx].transactions) { transaction in
                    NavigationLink(destination: TransactionDetailView(person: self.person, transaction: transaction)) {
                        TransactionRow(person: self.person, transaction: transaction)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(data.store.people[pIdx].name)
        .navigationBarItems(trailing: Button(action: {
            self.showAdd = true
        }) {
            HStack {
                Text("New transaction")
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
            }
        })
        //.sheet(isPresented: self.$showAdd, content: {NewTransactionView(pIdx: self.pIdx)})
        .sheet(isPresented: self.$showAdd, content: {NewTransactionView(person: self.person).environmentObject(self.data)})
    }
    
    func delete(at offsets: IndexSet) {
        data.store.people[pIdx].transactions.remove(atOffsets: offsets)
        print(data.store)
    }
    
}


struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsList(person: peopleStore.people[0])
            .environment(\.colorScheme, .dark)
            .environmentObject(UserData())
    }
}
