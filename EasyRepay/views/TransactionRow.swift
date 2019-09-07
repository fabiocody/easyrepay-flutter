//
//  TransactionRow.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionRow: View {
    
    @EnvironmentObject var data: UserData
    
    var person: Person
    var transaction: Transaction
    
    var pIdx: Int {
        data.store.index(of: person)
    }
    
    var tIdx: Int {
        data.store.people[pIdx].index(of: transaction)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.note)
                    .allowsTightening(true)
                Text("\(dateFormatter.string(for: Date(timeIntervalSince1970: TimeInterval(transaction.timestamp))) ?? "")")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .allowsTightening(true)
            }
            Spacer()
            Text("\(currencyFormatter.string(for: transaction.amount) ?? "")")
                .foregroundColor(Colors.amountColor(transaction: transaction))
        }
    }
    
}


struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionRow(person: peopleStore.people[0], transaction: peopleStore.people[0].transactions[0])
            TransactionRow(person: peopleStore.people[0], transaction: peopleStore.people[0].transactions[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
        .environmentObject(UserData())
    }
}
