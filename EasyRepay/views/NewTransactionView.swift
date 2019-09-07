//
//  NewTransactionView.swift
//  EasyRepay
//
//  Created by Fabio Codiglioni on 07/09/2019.
//  Copyright © 2019 Fabio Codiglioni. All rights reserved.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                TransactionDetail(transaction: Transaction())
                Button("Insert", action: {
                    //ModelHelper.insertPerson(name: self.name)
                    self.presentationMode.wrappedValue.dismiss()
                })
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 55)
                    .background(Color.green)
                    .cornerRadius(15.0)
                Spacer()
            }
            .padding()
            .navigationBarTitle("New transaction")
            .navigationBarItems(leading: Button("Cancel", action: {
                //self.name = ""
                self.presentationMode.wrappedValue.dismiss()
            }).accentColor(.green))
        }
    }
    
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView().environment(\.colorScheme, .light)
    }
}
