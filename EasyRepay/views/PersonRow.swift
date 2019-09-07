//
//  PersonRow.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct PersonRow: View {
    
    @EnvironmentObject var data: UserData
    
    var person: Person
    
    var pIdx: Int {
        data.store.index(of: person)
    }
    
    var totalAmount: Double {
        let amounts = data.store.people[pIdx].transactions.map({$0.amount})
        return amounts.reduce(0, +)
    }
        
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(data.store.people[pIdx].name)
                    .allowsTightening(true)
                Text("\(data.store.people[pIdx].transactions.count) " + (data.store.people[pIdx].transactions.count == 1 ? "transaction" : "transactions"))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(currencyFormatter.string(for: totalAmount)!)")
                .foregroundColor(Colors.amountColor(person: data.store.people[pIdx]))
        }
    }
    
}


struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonRow(person: peopleStore.people[0])
            PersonRow(person: peopleStore.people[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
        .environmentObject(UserData())
    }
}
