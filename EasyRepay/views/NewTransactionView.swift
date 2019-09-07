//
//  NewTransactionView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct NewTransactionView: View {
    
    var person: Person
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var typeSelection: Int = 0
    @State var amount: Double = 0
    @State var reason: String = ""
    @State var date: Date = Date()
    
    var body: some View {
        NavigationView {
            TransactionDetail(typeSelection: $typeSelection, amount: $amount, reason: $reason, date: $date)
                .padding()
                .navigationBarTitle("New transaction")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        // TODO Erase state
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .accentColor(.green)
                    , trailing: Button("Save") {
                        // TODO Save
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
        Group {
            NewTransactionView(person: peopleStore.people[0]).environment(\.colorScheme, .dark)
            NewTransactionView(person: peopleStore.people[0]).environment(\.colorScheme, .light)
        }
    }
}
