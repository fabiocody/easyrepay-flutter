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
    
    @State private var reason: String = ""
    @State private var temp1: String = ""
    @State private var temp2: String = ""
    @State private var temp3: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text("Field1")
                    .font(.headline)
                    .padding(.leading, 20)
                TextField("Enter name", text: $temp1)
                    .padding()
                    .background(Color.secondary.opacity(0.45))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }
            VStack(alignment: .leading) {
                Text("Field2")
                    .font(.headline)
                    .padding(.leading, 20)
                TextField("Enter name", text: $temp2)
                    .padding()
                    .background(Color.secondary.opacity(0.45))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }
            VStack(alignment: .leading) {
                Text("Reason")
                    .font(.headline)
                    .padding(.leading, 20)
                TextField("Enter reason", text: $reason)
                    .padding()
                    .background(Color.secondary.opacity(0.45))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }
            VStack(alignment: .leading) {
                Text("Field3")
                    .font(.headline)
                    .padding(.leading, 20)
                TextField("Enter name", text: $temp3)
                    .padding()
                    .background(Color.secondary.opacity(0.45))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }
            Spacer()
        }
    }
    
}


struct TransactionDetail_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetail(transaction: peopleStore.people[0].transactions[0])
            .environment(\.colorScheme, .light)
    }
}
