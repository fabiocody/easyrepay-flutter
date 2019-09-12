//
//  PersonRow.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct PersonRow: View {
    
    @ObservedObject var person: Person
        
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                TextField("Enter name", text: $person.name, onCommit: commit)
                    .allowsTightening(true)
                    .padding(.top, 5)
                    .padding(.bottom, -5)
                Text("\(person.transactions.count) " + (person.transactions.count == 1 ? "transaction" : "transactions"))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(currencyFormatter.string(for: abs(person.totalAmount))!)")
                .foregroundColor(Colors.amountColor(person: person))
        }
    }
    
    func commit() {
        dataStore.sortPeople()
        dataStore.save()
    }
    
}


struct PersonRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonRow(person: dataStore.people[0])
            PersonRow(person: dataStore.people[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
