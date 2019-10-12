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
    
    var initials: String {
        let maxCharacters = 3
        let splits = person.name.components(separatedBy: " ").map({$0.first!.uppercased()})
        if splits.count > maxCharacters { return splits[0..<maxCharacters].joined() }
        return splits.joined()
    }
        
    var body: some View {
        HStack(alignment: .center) {
            ZStack(alignment: .center) {
                Circle()
                    .frame(width: 50, height: 50, alignment: .center)
                    .foregroundColor(.green)
                Text(initials)
                    .font(Font.system(size: 22))
            }
            Spacer()
            VStack(alignment: .leading) {
                TextField("Enter name", text: $person.name, onCommit: commit)
                    .allowsTightening(true)
                    .autocapitalization(.words)
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
        PeopleList()
            .environment(\.colorScheme, .light)
    }
}
