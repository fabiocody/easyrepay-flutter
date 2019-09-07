//
//  PersonRow.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct PersonRow: View {
    
    var person: Person
    
    var totalAmount: Double {
        let amounts = person.transactions.map({$0.amount})
        return amounts.reduce(0, +)
    }
        
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(person.name)
                    .allowsTightening(true)
                Text("\(person.transactions.count) transactions")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(currencyFormatter.string(for: totalAmount)!)")
                .foregroundColor(Colors.amountColor(person: person))
        }
    }
    
}


struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonRow(person: peopleStore.people[0])
            PersonRow(person: peopleStore.people[1])
            PersonRow(person: peopleStore.people[2])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
