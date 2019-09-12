//
//  TransactionRow.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionRow: View {
        
    @ObservedObject var transaction: Transaction
    
    @Binding var showCompleted: Bool
    
    var body: some View {
        HStack {
            if showCompleted {
                Image(systemName: transaction.completed ? "checkmark" : "xmark")
                    .padding(.leading, 5)
                    .foregroundColor(transaction.completed ? .green : .red)
                    .transition(.scale)
            }
            VStack(alignment: .leading) {
                Text(transaction.note)
                    .allowsTightening(true)
                Text("\(dateFormatter.string(for: transaction.date)!)")
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
            TransactionRow(transaction: dataStore.people[0].transactions[0], showCompleted: .constant(true))
            TransactionRow(transaction: dataStore.people[0].transactions[1], showCompleted: .constant(true))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
