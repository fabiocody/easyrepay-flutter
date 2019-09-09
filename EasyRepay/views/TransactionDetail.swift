//
//  TransactionDetail.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 04/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI


struct TransactionDetail: View {
                
    @Binding var typeSelection: Int
    @Binding var amount: Double?
    @Binding var note: String
    @Binding var date: Date
    
    var body: some View {
        Form {
            Picker(selection: $typeSelection, label: Text("Type")) {
                ForEach(0..<TransactionType.allCases.count) {
                    Text(TransactionType.allCases[$0].rawValue).tag($0)
                        .accentColor(.green)
                }
            }
            .accentColor(.green)
            HStack(alignment: .center) {
                Text("Amount")
                Spacer()
                TextField("Enter amount", value: $amount, formatter: currencyFormatter, onEditingChanged: {
                    if $0 && self.amount == 0 {
                        self.amount = nil
                    }
                })
                .keyboardType(.numbersAndPunctuation)
                .lineLimit(5)
                .multilineTextAlignment(.trailing)
            }
            HStack(alignment: .center) {
                Text("Note")
                Spacer()
                TextField("Enter note", text: $note)
                    .multilineTextAlignment(.trailing)
            }
            DatePicker(selection: $date, label: {Text("Date")})
        }
    }
    
}


struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetail(typeSelection: .constant(0), amount: .constant(0), note: .constant(""), date: .constant(Date()))
            .environment(\.colorScheme, .light)
    }
}
