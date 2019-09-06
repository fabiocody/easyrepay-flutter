//
//  TransactionsList.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct TransactionsList: View {
    
    @State private var reminderActive = false
    
    var person: Person
    
    var body: some View {
        Group {
            if person.transactions.count > 0 {
                List {
                    Section() {
                        ForEach(person.transactions, id: \.id) { t in
                            NavigationLink(destination: TransactionDetail(transaction: t)) {
                                TransactionRow(transaction: t)
                            }
                        }
                    }
                    Section(header: Text("Reminder")) {
                        Toggle(isOn: $reminderActive) {
                            Text("Activate reminder")
                        }
                        if reminderActive {
                            Text("Ciao")
                            Text("Ciao ciao")
                        }
                    }

                }
                .listStyle(GroupedListStyle())
            } else {
                Text("No data")
            }
        }
        .navigationBarTitle(person.name)
    }
}

struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionsList(person: peopleStore.people[0]).environment(\.colorScheme, .dark)
            TransactionsList(person: peopleStore.people[1]).environment(\.colorScheme, .light)
        }
    }
}
