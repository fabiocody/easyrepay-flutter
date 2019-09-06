//
//  TransactionDetail.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct TransactionDetail: View {
    var transaction: Transaction
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Type")
                    Spacer()
                }
            }
            Section {
                HStack {
                    Text("Amount")
                    Spacer()
                }
            }
            Section {
                HStack {
                    Text("Reason")
                    Spacer()
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetail(transaction: peopleStore.people[0].transactions[0])
    }
}
